from businesslogic.verify import verify, update_user_status
from work.mongo import MongoWorkQueue
import time


class VerifyProcessWorker():

    __running_job = False
    __job_pipeline = None
    __job_refresh = 0
    __id = None

<<<<<<< HEAD:src/python/work/verifyprocess.py
    def __init__(self, _id, job_refresh=60):
=======
    def __init__(self, _id, job_refresh=15):
>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/work/verifyprocess.py
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

<<<<<<< HEAD:src/python/work/verifyprocess.py
                print("[SELECTED JOB {}]".format(job["guid"]))
                self.__process_job(job)

        except Exception as e:
            print(str(e))

    def __process_job(self, job):

        verified, message = verify(job)

        update_user_status(verified, message, job['guid'])
=======
                print("[SELECTED JOB {}]".format(str(job["_id"])))
                self.__process_job(job)

        except Exception as e:
            print(e)

    def __process_job(self, job):        
        update_user_status(*verify(job), id=job["UserId"])


>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/work/verifyprocess.py
