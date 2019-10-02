from pymongo import MongoClient
import datetime


class MongoWorkQueue():

    __client = None
    __queue = None

    def __init__(self, host, port):
        try:
            self.__client = MongoClient(
                host=host, port=port, connect=True)

            db = self.__client["idanywhere"]
            self.__queue = db["queue"]
            print(
                "[CONNECTED TO MONGODB INSTANCE ON {0}:{1}]".format(host, port))
        except Exception as e:
            print("Could not connect to local mongodb server.")

    def get_next_job(self):
        work = self.__queue.find_and_modify(
            query={"start_time": None},
            sort={"_id": 1},
            update={"$set": {"start_time": datetime.datetime.now()}})
        return work

    def mark_done(work_job):
        try:
            print('[{}] Complete'.format(work_job.guid))
            __queue.delete_one(work_job)
            print('[{}] Successfully removed from work queue.'.format(
                work_job.guid))
        except Exception as e:
            print('Error removing work job from the queue: {}'.format(str(e)))

    def create_test_job(self):

        testdoc = {
            "passport_bytes":,
            "user_image_bytes":,
            "license_bytes":,
            "guid":,
            "passport_bytes": }

        self.__queue.insert_one()
