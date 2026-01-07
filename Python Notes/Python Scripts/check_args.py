import sys
import os

#prints the script name
print("This is the name of the program:", sys.argv[0])

#checks if the arguments were passed
if len(sys.argv) <= 1:
    print("Error: No arguments passed.")
else:
    args = sys.argv[1:]

    print("Number of arguments passed:", len(args))
    print("Argument list:", args)

    for arg in args:
        print(arg)






