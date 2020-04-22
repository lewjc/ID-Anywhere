import sys
import work.workfactory
from multiprocessing import Process


connection_string = None
connection_string_help = "Connection string for the mongo db work queue"
display_help = False
version = '1.0.0'

header = ('''
  ___ ___      _                   _                 
 |_ _|   \    /_\  _ _ _  ___ __ _| |_  ___ _ _ ___  
  | || |) |  / _ \| ' \ || \ V  V / ' \/ -_) '_/ -_) 
 |___|___/  /_/ \_\_||_\_, |\_/\_/|_||_\___|_| \___| 
                       |__/                                                                                                 
__   __       _  __         _   _            ___              _        
\ \ / /__ _ _(_)/ _|__ __ _| |_(_)___ _ _   / __| ___ _ ___ _(_)__ ___ 
 \ V / -_) '_| |  _/ _/ _` |  _| / _ \ ' \  \__ \/ -_) '_\ V / / _/ -_)
  \_/\___|_| |_|_| \__\__,_|\__|_\___/_||_| |___/\___|_|  \_/|_\__\___|
''')


arg_vals = {
    "--connectionstring": {
        "var": connection_string,
        "help_text": connection_string_help
    },
    "-c": {
        "var": connection_string,
        "help_text": connection_string_help
    }, "--help": {
        "var": display_help,
        "help_text": None
    },
    "-h": {
        "var": display_help,
        "help_text": None
    }
}


def main():
    # if(len(sys.argv) == 1):
    #     print("No arguments provided",)
    #     return
    print(header)
    print(
        "\n[STARTING ID ANYWHERE VERIFICATION SERVICE] VERSION: {0}\n ".format(
            version))

    valid_arguments = arg_parser((sys.argv.copy()).pop(0))
    if(not valid_arguments):
        print("Invalid arguments")
        return

<<<<<<< HEAD:src/python/main.py
    work_factory = work.workfactory.WorkFactory(3, 60)
=======
    work_factory = work.workfactory.WorkFactory(1, 15)
>>>>>>> 17591920e293ed362a59843b45ea00782494a144:src/daemon/main.py
    p = Process(target=work_factory.initialise)
    p.start()

    while(True):
        exit = input('')
        if(exit.lower() == 'exit'):
            print("Waiting for jobs to finish...")
            work_factory.finish_work()
            print("bye")
            p.terminate()
            sys.exit()


def arg_parser(args):
    if(str(args[0]).lower() == "-h" or str(args[0]).lower() == "-help"):
        print_help()
    else:
        return True


def print_help():
    print('help')
    # TODO iterate through keys and values.


if __name__ == '__main__':
    main()
