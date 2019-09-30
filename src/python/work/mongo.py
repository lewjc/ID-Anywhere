from pymongo import MongoClient
from pprint import pprint
import datetime


class MongoWorkQueue():

    __client = None
    __queue = None

    def __init__(self, mongo_url):
        client = MongoClient(mongo_url)
        __queue = client.queue

    def get_next_job():
        work = __queue.findAndModify(
            query={},
            sort={_id: 1},
            update={"$set": {start_time: datetime.datetime.now()}})
        return work

    def mark_done(work_job):
        try:
            print('[{}] Complete'.format(work_job.guid))
            __queue.delete_one(work_job)
            print('[{}] Successfully removed from work queue.'.format(
                work_job.guid))
        except Exception as e:
            print('Error removing work job from the queue: {}'.format(str(e)))
