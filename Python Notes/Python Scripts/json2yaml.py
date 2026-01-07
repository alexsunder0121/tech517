import json
import os
import sys
import yaml

# Checking there is a file name passed
if len(sys.argv) > 1:
    # Opening the file
    if os.path.exists(sys.argv[1]):
        source_file = open(sys.argv[1], "r")
        source_content = json.load(source_file)
        source_file.close()
    # Failing if the file isn't found
    else:
        print("ERROR: " + sys.argv[1] + " not found")
        exit(1)
# No source file specified
else:
    print("ERROR: No JSON file was specified")
    print("Usage: json2yaml.py <source_file.json> <target_file.yaml>")

# 1. Convert the JSON to YAML - use yaml library
# WRITE YOUR CODE HERE
yaml_content = yaml.dump(source_content)

# 2. Save the YAML into a new file with the name for it received as a argument
# 2.1 Check the target file name was specified as an argument, if not, output the YAML to the screen instead
# WRITE YOUR CODE HERE
if len(sys.argv) < 3:
    print(yaml_content)
    exit(0)
target_file = sys.argv[2]

# 2.2 Check the target file doesn't already exist
# WRITE YOUR CODE HERE
if os.path.exists(target_file):
    print("ERROR: " + target_file + " already exists")
    exit(1)

# 2.3 If previous conditions not met, then save YAML file
# WRITE YOUR CODE HERE
yaml_file = open(target_file, "w")
yaml_file.write(yaml_content)
yaml_file.close()

print("YAML file created:", target_file)