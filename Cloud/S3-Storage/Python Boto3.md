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
