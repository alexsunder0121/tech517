import json

#read json file into the directory
try:
    with open("severs.json", "r") as json_file:
        servers_dict = json.load(json_file)
except FileNotFoundError:
    print("No file found")
    exit()


required_fields = ["hostname", "ip_address", "role", "status"]
is_valid = True

# Validation
for server_name in servers_dict:
    server = servers_dict[server_name]

    for field in required_fields:
        if field not in server:
            is_valid = False

# Final result
if is_valid:
    print("VALID: servers.json passed basic validation")
else:
    print("INVALID: servers.json failed validation")



