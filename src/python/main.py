from sys import argv
from termcolor import colored

arg_vals = dict({
    "-c, --connectionstring": "URL of mongo db work queue",    
})
connection_string = None


def main():
    # DO STUFFS :)
    if(len(sys.argv)):
        print colored("No arguments provided",)
        return
    valid_arguments = arg_parser(sys.argv.pop(0))
    if(!valid_arguments):
        print("Invalid arguments")
        return

    work_queue = MongoWorkQueue()
    

def arg_parser(args):
    if(str(args[0]).lower() == "-h" or str(args[0]).lower() == "-help"):
        print_help()


def print_help():
    print('help')
    # TODO iterate through keys and values.
