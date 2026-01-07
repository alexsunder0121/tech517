import json

# create the dictionary
servers_dict = {
    "server1": {
        "hostname": "web-server-1",
        "ip_address": "192.168.1.1",
        "role": "web",
        "status": "active"
    },
    "server2": {
        "hostname": "db-server-1",
        "ip_address": "192.168.1.2",
        "role": "database",
        "status": "maintenance"
    }
}
print(servers_dict)
print(type(servers_dict))

#created json string
servers_json_str = json.dumps(servers_dict)
print(servers_json_str)
print(type(servers_json_str))

#created json file
with open('servers.json', 'w') as json_file:
    json.dump(servers_dict, json_file)

#read in json string
servers_new_dict = json.loads(servers_json_str)
print(type(servers_new_dict))

#read json file
try:
    with open('servers.json') as json_file:
      servers_from_file = json.load(json_file)
except FileNotFoundError:
    print("No file found")

#print (servers_from_file)


