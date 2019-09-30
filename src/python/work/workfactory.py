from work.mongo import MongoWorkQueue
from multiprocessing import Pool, TimeoutError


class WorkFactory():

    __thread_pool = None
    __work_queue = None
    __max_workers = None

    safe_exit = False

    __init__(max_workers):
        __work_queue = MongoWorkQueue()
        __max_workers = max_workers
        __thread_pool = Pool(processes=__max_workers)

    spawn_task():
        # TODO init threadpool and spawn tasks in work pool.

