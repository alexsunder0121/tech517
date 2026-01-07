import json
import sys
import os
import yaml

# check a YAML file was provided
if len(sys.argv) < 2:
    #if no file name provided it stops
    print("ERROR, NO YAML file has been specified")
    print("Usage: python3 {sys.argv[0]} <source.file> <target.json")
    exit(1)

source_file = sys.argv[1]

# check the YAML file exists
if not os.path.isfile(source_file):
    print("ERROR, NO file is found", source_file)
    exit(1)

# load YAML into Python Directory
with open(source_file) as file:
    source = yaml.safe_load(file)

# convert dictionary into JSON text
json_text = json.dumps(source, indent=4)

# if no target file is given, print it to screen
if len(sys.argv) < 3:
    print(json_text)
    exit(0)
else:
    target_file = sys.argv[2]
    with open(target_file) as file:
        file.write(json_text)
    print("SUCCESS, JSON file created", target_file)

