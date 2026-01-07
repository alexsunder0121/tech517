import sys
import os
import yaml

#check the user passed a filename
if len(sys.argv) <= 2:
    #if no file name provided it stops
    print("ERROR, NO YAML file has been specified")
    print("Usage: python3 {sys.argv[0]} <YAML file>")
    exit(1)

#gets the filename from the argument
yaml_file = sys.argv[1]

with open(yaml_file, "r") as file:
    #opens the file and loads YAML into python
    data = yaml.load_file(file)

#prints data and type
print(data)
print(type(data))
