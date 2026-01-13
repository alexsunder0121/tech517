import requests
import json

post_codes_req = requests.get("https://api.postcodes.io/postcodes/BR87RE")
data_dict = post_codes_req.json()

json_body = json.dumps({"postcodes": ["PR3 0SG", "M45 6GN", "EX165BL"]})
headers = {'content-type': 'application/json'}
post_multi_req = requests.post("https://api.postcodes.io/postcodes", headers=headers, data=json_body)

print(post_multi_req.json()['result'][0])




# PART 1 - requests

# print(post_codes_req)
# print(f"Status code: {post_codes_req.status_code}")
# print(f"headers: {post_codes_req.headers}")
# print(f"content: {post_codes_req.content}")
# print(f"JSON: {post_codes_req.json()}")

#data_dict = post_codes_req.json()

# print(type(data_dict))
# print(type(data_dict['result']['postcode']))
# print(data_dict['result']['postcode'][0:3])





