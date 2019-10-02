from work.mongo import MongoWorkQueue
from work.verifyprocess import VerifyProcess
from multiprocessing import Process


class WorkFactory():

    __process_pool = None
    __work_queue = None
    __max_workers = None
    __job_sleep = 0
    safe_exit = False
    busy = not len(__process_pool) < __max_workers

    def __init__(self, max_workers, job_sleep=60):
        self.__work_queue = MongoWorkQueue()
        self.__max_workers = max_workers
        self.__process_pool = []
        self.__job_sleep = job_sleep

    def initialise(self):
        while True:
            job = self.__work_queue.get_next_job()

            if(job is None):
                time.sleep(self.__job_sleep)
                continue

            self.__do_work(VerifyProcess(job, self.__on_work__finish))

    def __do_work(self, task, args):
        if(self.busy):
            new_proc = Process(target=(task), args=args)
            new_proc.start()
            self.__thread_pool.append(new_proc)

    def __on_work__finish(self, thread_idx):
        self.__process_pool.pop(thread_idx)
