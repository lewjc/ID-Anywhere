from businesslogic.verify import verify, update_user_status


class VerifyProcess():

    __passport_image_bytes = None
    __user_image_bytes = None
    __license_image_bytes = None
    __guid = None
    process_finish_callback = None

    def __init__(self, mongo_job, process_finish_callback):
        self.__passport_image_bytes = mongo_job.passport_bytes
        self.__user_image_bytes = mongo_job.user_image_bytes
        self.__license_image_bytes = mongo_job.license_bytes
        self.__guid = mongo_job.user_guid
        self.run()

    def run():
        try:
            # Do our verification then run the callback
            verified, message = verify(
                self.passport_image_bytes,
                self.user_image_bytes,
                self.driving_license_image_bytes)

            update_user_status(verified, message)
            if(self.process_finish_callback is not None):
                self.process_finish_callback()

        except Exception as e:
            print(str(e))

