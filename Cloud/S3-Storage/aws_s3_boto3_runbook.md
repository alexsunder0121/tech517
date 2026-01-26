# Working with AWS S3 Using AWS CLI and Python boto3

## Overview

In this task, I configured the AWS CLI and Python **boto3** on an EC2 instance and used them to interact with Amazon S3. The purpose was to understand how AWS authentication works, how S3 buckets are created and managed, and how Python can be used to automate AWS tasks instead of relying only on manual CLI commands.

This documentation is written at a beginner-friendly level and explains what each script does and why it is needed.

---

## What is boto3 and Why Use It?

boto3 is the official AWS SDK for Python. It allows Python code to interact directly with AWS services.

Using boto3, you can:
- Automate AWS tasks using Python scripts
- Create, list, and delete AWS resources
- Upload and download files from S3 programmatically
- Replace repetitive CLI commands with reusable code

In this task, boto3 is used to manage Amazon S3.

---

## Script 1: List All S3 Buckets

### Purpose
This script lists all S3 buckets that belong to your AWS account. It is often the first check to confirm that boto3 authentication is working correctly.

### Code
```python
import boto3

s3 = boto3.client("s3")
response = s3.list_buckets()

for bucket in response["Buckets"]:
    print(bucket["Name"])
```

### Explanation
- boto3.client("s3") creates a connection to the S3 service
- list_buckets() retrieves all buckets owned by the account
- Each bucket name is printed to the screen

---

## Script 2: Create an S3 Bucket

### Purpose
This script creates a new S3 bucket in a specific AWS region.

### Code
```python
import boto3

BUCKET_NAME = "tech517-alex-test-boto3"
REGION = "eu-west-1"

s3 = boto3.client("s3", region_name=REGION)

s3.create_bucket(
    Bucket=BUCKET_NAME,
    CreateBucketConfiguration={"LocationConstraint": REGION}
)

print("Bucket created:", BUCKET_NAME)
```

### Explanation
- Bucket names must be globally unique and lowercase
- The region is specified to control where the data is stored
- create_bucket() sends the request to AWS

---

## Script 3: Upload a File to S3

### Purpose
Uploads a local file from the EC2 instance into the S3 bucket.

### Code
```python
import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "tech517-alex-test-boto3"
LOCAL_FILE = "test.txt"
S3_KEY = "test.txt"

s3 = boto3.client("s3")

try:
    s3.upload_file(LOCAL_FILE, BUCKET_NAME, S3_KEY)
    print("Upload successful")
except ClientError as e:
    print("Upload failed:", e)
```

---

## Script 4: Download a File from S3

### Purpose
Downloads a file from S3 back onto the EC2 instance.

### Code
```python
import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "tech517-alex-test-boto3"
S3_KEY = "test.txt"
DOWNLOAD_TO = "downloaded_test.txt"

s3 = boto3.client("s3")

try:
    s3.download_file(BUCKET_NAME, S3_KEY, DOWNLOAD_TO)
    print("Download successful")
except ClientError as e:
    print("Download failed:", e)
```

---

## Script 5: Delete a File from S3

### Purpose
Deletes a single file from the S3 bucket.

### Code
```python
import boto3

BUCKET_NAME = "tech517-alex-test-boto3"
S3_KEY = "test.txt"

s3 = boto3.client("s3")
s3.delete_object(Bucket=BUCKET_NAME, Key=S3_KEY)

print("File deleted")
```

---

## Script 6: Delete the S3 Bucket

### Purpose
Deletes the S3 bucket after ensuring it is empty.

### Code
```python
import boto3

BUCKET_NAME = "tech517-alex-test-boto3"

s3 = boto3.resource("s3")
bucket = s3.Bucket(BUCKET_NAME)

bucket.objects.all().delete()
bucket.delete()

print("Bucket deleted")
```

---

## Summary

This task demonstrated how Python and boto3 can be used to manage AWS S3 resources in a simple, repeatable, and automated way. These scripts form the foundation for more advanced AWS automation tasks.




















# Working with AWS S3 Using the AWS CLI and boto3

Overview: 

In this task, I set up the AWS CLI and Python boto3 on an EC2 instance and used them to interact with Amazon S3. The goal was to understand how authentication works, how S3 buckets are created, and how Python can be used to manage AWS resources programmatically.

## What is boto3 and Why Use It?

boto3 is the official AWS SDK for Python.

It allows you to:
	•	Automate AWS tasks using Python
	•	Create and manage AWS resources in code
	•	Build applications that interact with AWS services
	•	Replace manual CLI commands with reusable scripts

In this task, boto3 is used to manage Amazon S3.

⸻

## Script 1: List All S3 Buckets Using Python (boto3)

```
import boto3

# Create an S3 client
s3 = boto3.client('s3')

# Get a list of all S3 buckets
response = s3.list_buckets()

# Print each bucket name
for bucket in response['Buckets']:
    print(bucket['Name'])
```

## Create an S3 bucket (boto3)

1. create a file : nano 1_create_bucket.py
2. Code imported:
   ```import boto3

BUCKET_NAME = "tech517-alex-test-boto3"   # change this to your bucket name
REGION = "eu-west-1"

s3 = boto3.client("s3", region_name=REGION)

s3.create_bucket(
    Bucket=BUCKET_NAME,
    CreateBucketConfiguration={"LocationConstraint": REGION}
)

print("Bucket created:", BUCKET_NAME)```

3. Run this script: ```python3 1_create_bucket.py```
4. Confirm the bucket exists: `aws s3 ls`

## Upload data/file to the S3 bucket

1. Make a test file: echo "hello from my vm" > test.txt
ls -l test.txt
2. create your script: `nano 2_upload_file.py`
3. Paste into the script: 
   `
   import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "tech517-alex-test-boto3"
LOCAL_FILE = "test.txt"
S3_KEY = "test.txt"

s3 = boto3.client("s3")

try:
    s3.upload_file(LOCAL_FILE, BUCKET_NAME, S3_KEY)
    print(f"Uploaded {LOCAL_FILE} to s3://{BUCKET_NAME}/{S3_KEY}")
except ClientError as e:
    print("Upload failed:", e)
   `

Run script: `python3 2_upload_file.py`

## Script 2: Download a file (3_download_file.py)

1. nano 3_download_file.py
2. import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "tech517-alex-test-boto3"
S3_KEY = "test.txt"
DOWNLOAD_TO = "downloaded_test.txt"

s3 = boto3.client("s3")

try:
    s3.download_file(BUCKET_NAME, S3_KEY, DOWNLOAD_TO)
    print(f"Downloaded s3://{BUCKET_NAME}/{S3_KEY} to {DOWNLOAD_TO}")
except ClientError as e:
    print("Download failed:", e)

3. python3 3_download_file.py
4. ls -l downloaded_test.txt
cat downloaded_test.txt


## Script 3: Delete a file (4_delete_file.py)

1. nano 4_delete_file.py
2. import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "tech517-alex-test-boto3"
S3_KEY = "test.txt"

s3 = boto3.client("s3")

try:
    s3.delete_object(Bucket=BUCKET_NAME, Key=S3_KEY)
    print(f"Deleted s3://{BUCKET_NAME}/{S3_KEY}")
except ClientError as e:
    print("Delete failed:", e)

3. python3 4_delete_file.py
4. aws s3 ls s3://tech517-alex-test-boto3/

## Script 4: Delete the bucket (5_delete_bucket.py)

1. nano 5_delete_bucket.py
2. import boto3
from botocore.exceptions import ClientError

BUCKET_NAME = "tech517-alex-test-boto3"

s3 = boto3.resource("s3")
bucket = s3.Bucket(BUCKET_NAME)

try:
    bucket.objects.all().delete()
    print("Emptied bucket:", BUCKET_NAME)

    bucket.delete()
    print("Deleted bucket:", BUCKET_NAME)

except ClientError as e:
    print("Bucket delete failed:", e)

3. python3 5_delete_bucket.py
4. aws s3 ls | grep tech517-alex-test-boto3
5. 