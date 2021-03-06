from work.mongo import MongoWorkQueue
from work.verifyprocess import VerifyProcessWorker
from multiprocessing import Process
import sys
import time
import uuid


class WorkFactory():

    __worker_pool = []
    __worker_sleep = 0
    __finalise_work = False
    __workers = 0

<<<<<<< HEAD:src/python/work/workfactory.py
    def __init__(self, workers=3, worker_sleep=60):
=======
    def __init__(self, workers=1, worker_sleep=15):
>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/work/workfactory.py
        self.__workers = workers
        self.__worker_sleep = worker_sleep
        print("[INITIALISED WORK FACTORY]")

    def initialise(self):
<<<<<<< HEAD:src/python/work/workfactory.py
=======

>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/work/workfactory.py
        print("[GENERATING WORKERS]")

        for x in range(self.__workers):
            uid = str(uuid.uuid4())
            worker = VerifyProcessWorker(uid, self.__worker_sleep)

            worker_proc = Process(target=worker.run,
                                  args=(self.__finalise_work,))
            worker_proc.start()
            print("[CREATED WORKER {}]".format(uid))
            self.__worker_pool.append(worker_proc)

    def finish_work(self):
        self.__finalise_work = True
        for worker in self.__worker_pool:
            worker.join()
<<<<<<< HEAD:src/python/work/workfactory.py
=======



>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/work/workfactory.py
