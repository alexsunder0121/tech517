import yaml

#try to load YAML file
try:
    with open("severs.yaml", "r") as file:
        servers_dict = yaml.safe_load(file)
except FileNotFoundError:
    print("INVALID, No file found")
    exit()

#define the fields we expect each server to have
required_fields = ["hostname", "ip_address", "role", "status"]
is_valid = True

# Validation - checking each serer has the required fields
for server_name in servers_dict:
    server = servers_dict[server_name]

    for field in required_fields:
        if field not in server:
            is_valid = False

# Final result-print each out
if is_valid:
    print("VALID: servers.yaml passed basic validation")
else:
    print("INVALID: servers.yaml failed validation")