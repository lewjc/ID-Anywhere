from businesslogic.verify import verify, update_user_status
from work.mongo import MongoWorkQueue
import time


class VerifyProcessWorker():

    __running_job = False
    __job_pipeline = None
    __job_refresh = 0
    __id = None

    def __init__(self, _id, job_refresh=60):
        self.__id = _id
        self.__job_refresh = job_refresh

    def run(self, exit_condition):
        self.__job_pipeline = MongoWorkQueue(parent=self.__id)

        try:
            while True:
                if(exit_condition):
                    return
                job = self.__job_pipeline.get_next_job()
                if(job is None):
                    time.sleep(self.__job_refresh)
                    continue

                print("[SELECTED JOB {}]".format(job["guid"]))
                self.__process_job(job)

        except Exception as e:
            print(str(e))

    def __process_job(self, job):

        verified, message = verify(
            job["passport_bytes"],
            job["user_image_bytes"],
            job["license_image_bytes"])

        update_user_status(verified, message, job['guid'])
