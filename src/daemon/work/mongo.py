from pymongo import MongoClient
import datetime
from io import BytesIO
import os


class MongoWorkQueue():

    def __init__(self, host="127.0.0.1", port=27017, parent=""):
        try:
            self.__client = MongoClient(
                host=host, port=port, connect=True)
            db = self.__client["idanywhere"]
            self.__queue = db["queue"]
            # self.create_test_job()
            print(
                "[{0} CONNECTED TO MONGO DB INSTANCE @ {1}:{2}]".format(
                    parent, host, port))
        except Exception as e:
            print(e)
            print("Could not connect to local mongodb server.")

    def get_next_job(self):
        work = self.__queue.find_one_and_update(
            filter={"start_time": None, "Ready": True},
            sort=[("_id", 1)],
            update={"$set": {"start_time": datetime.datetime.now()}})

        if(work is None):
            return None

        return work.copy()

    def mark_done(self, work_job):
        try:
            print('[{}] Complete'.format(work_job.id))
            self.__queue.delete_one(work_job)
            print('[{}] Successfully removed from work queue.'.format(
                work_job.id))
        except Exception as e:
            print('Error removing work job from the queue: {}'.format(str(e)))
