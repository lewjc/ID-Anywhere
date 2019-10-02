from sys import argv
from termcolor import colored
import work.workfactory

connection_string = None
connection_string_help = "Connection string for the mongo db work queue"
display_help = False

arg_vals = {
    "--connectionstring": {
        var: connection_string,
        help_text: connection_string_help
    },
    "-c": {
        var: connection_string,
        help_text: connection_string_help
    }"--help": {
        var: display_help,
        help_text: None
    },
    "-h": {
        var: display_help,
        help_text: None
    }
}


class VerifyProcess():

    __init__():
        pass


def main():
    # DO STUFFS :)
    if(len(sys.argv)):
        print colored("No arguments provided",)
        return
    valid_arguments = arg_parser(sys.argv.pop(0))
    if(!valid_arguments):
        print("Invalid arguments")
        return

    work_factory = work.workfactory.WorkFactory(5, 120)
    work_factory.initialise()


def arg_parser(args):
    if(str(args[0]).lower() == "-h" or str(args[0]).lower() == "-help"):
        print_help()


def print_help():
    print('help')
    # TODO iterate through keys and values.
