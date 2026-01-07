import json
import os
import sys

if len(sys.argv) < 2:
    print("Please provide a folder")
    exit()

required_fields = ["hostname", "ip_address", "role", "status"]

for file in os.listdir(sys.argv[1]):

    if not file.endswith(".json"):
        continue

    try:
        data = json.load(open(sys.argv[1] + "/" + file))
    except:
        print(file, "INVALID")
        continue

    valid = True

    for server in data:
        for field in required_fields:
            if field not in data[server]:
                valid = False

    print(file, "VALID" if valid else "INVALID")
