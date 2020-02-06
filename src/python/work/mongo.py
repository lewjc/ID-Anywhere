from pymongo import MongoClient
import datetime
from PIL import Image
from gridfs import GridFS
from io import BytesIO
import os


class MongoWorkQueue():

    def __init__(self, host="127.0.0.1", port=27017, parent=""):
        try:
            self.__client = MongoClient(
                host=host, port=port, connect=True)
            db = self.__client["idanywhere"]
            self.__queue = db["queue"]
            self.__gridfs = GridFS(db)
            # self.create_test_job()
            print(
                "[{0} CONNECTED TO MONGO DB INSTANCE @ {1}:{2}]".format(
                    parent, host, port))
        except Exception as e:
            print(e)
            print("Could not connect to local mongodb server.")

    def get_next_job(self):
        work = self.__queue.find_one_and_update(
            filter={"start_time": None},
            sort=[("_id", 1)],
            update={"$set": {"start_time": datetime.datetime.now()}})

        if(work is None):
            return None

        work["passport_bytes"] = self.__load_bytes(
            {"_id": work["passport_id"]})

        work["user_image_bytes"] = self.__load_bytes(
            {"_id": work["user_image_id"]})
        work["license_image_bytes"] = self.__load_bytes(
            {"_id": work["license_id"]})

        return work.copy()

    def __load_bytes(self, filter):
        return self.__gridfs.find_one(filter).read()

    def mark_done(self, work_job):
        try:
            print('[{}] Complete'.format(work_job.guid))
            self.__queue.delete_one(work_job)
            print('[{}] Successfully removed from work queue.'.format(
                work_job.guid))
        except Exception as e:
            print('Error removing work job from the queue: {}'.format(str(e)))

    # DEBUG METHOD ONLY
    def create_test_job(self):
        dir = os.path.dirname(__file__)

        passport_image = self.__get_bytes(os.path.join(dir, "../passport.jpg"))
        passport_image = self.__gridfs.put(passport_image)
        me_image = self.__get_bytes(os.path.join(dir, "../me.jpg"))
        me_image = self.__gridfs.put(me_image)
        license_image = self.__get_bytes(os.path.join(dir, "../license.jpg"))
        license_image = self.__gridfs.put(license_image)

        testdoc = {
            "passport_id": passport_image,
            "user_image_id": me_image,
            "license_id": license_image,
            "guid": "jksdfhfjkebwwfjk234uirb23789hfuidn",
            "start_time": None
        }
        self.__queue.insert_one(testdoc)

    def __get_bytes(self, imagePath):
        with BytesIO() as output:
            with Image.open(imagePath) as img:
                img.save(output, 'JPEG')
            return output.getvalue()
