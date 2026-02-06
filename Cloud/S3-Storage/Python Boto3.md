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
- import boto3
    - Imports the AWS SDK for Python so the script can interact with AWS services.

- boto3.client("s3")
    - Creates a client object that allows the script to communicate with the Amazon S3 service using the AWS credentials already configured on the machine.

- list_buckets()
  - Sends a request to AWS to retrieve a list of all S3 buckets owned by the AWS account.

- response["Buckets"]
    - The response returned by AWS is a dictionary. The "Buckets" key contains a list of all bucket objects.

- for bucket in response["Buckets"]:
    - Loops through each bucket in the list.

- print(bucket["Name"])
    - Prints the name of each S3 bucket to the terminal.


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
- BUCKET_NAME
    - Stores the name of the S3 bucket to be created.
    - Bucket names must be globally unique, lowercase, and cannot contain spaces.
  
- REGION
    - Specifies the AWS region where the bucket will be created.
    - In this case, the bucket is created in the eu-west-1 (Ireland) region.

- boto3.client("s3", region_name=REGION)
    - Creates an S3 client that connects to the specified AWS region using the configured AWS credentials.

- create_bucket()
    - Sends a request to AWS to create a new S3 bucket with the given name and region.

- CreateBucketConfiguration
    - Required when creating buckets outside of the default region.
    - It ensures the bucket is created in the correct region.

- print("Bucket created:", BUCKET_NAME)
    - Confirms in the terminal that the bucket creation request was successful.
  
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

### Explanation
- from botocore.exceptions import ClientError
    - Imports the ClientError class so the script can handle AWS related errors gracefully.
  
- BUCKET_NAME
    - Specifies the name of the S3 bucket where the file will be uploaded.
  
- LOCAL_FILE
    - The name of the file stored locally on the EC2 instance that will be uploaded.

- S3_KEY
    - The name the file will have once it is stored in the S3 bucket.
    - In this case, the file keeps the same name.
  
- s3.upload_file(LOCAL_FILE, BUCKET_NAME, S3_KEY)
    - Uploads the local file from the EC2 instance to the specified S3 bucket.

- try / except block
    - Ensures that if something goes wrong during the upload (such as permissions issues or a missing file), the script does not crash and instead prints a helpful error message.

-   print("Upload successful")
    - Confirms in the terminal that the file was uploaded successfully.

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

### Explanation
- S3_KEY
    - Refers to the exact object name stored in the S3 bucket that you want to download.

- DOWNLOAD_TO
    - Specifies the name of the file once it is downloaded onto the EC2 instance.

- s3.download_file(BUCKET_NAME, S3_KEY, DOWNLOAD_TO)
    - Downloads the specified object from the S3 bucket and saves it locally using the filename defined in DOWNLOAD_TO.

- print("Download successful")
Confirms that the file has been successfully retrieved from S3.

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

### Explanation
- s3.delete_object(Bucket=BUCKET_NAME, Key=S3_KEY)
    - Sends a request to S3 to permanently remove the specified object (S3_KEY) from the given bucket.

- Deleting an object in S3 does not delete the bucket itself, only the file stored inside it.

- print("File deleted")
    - Confirms that the delete request was successfully sent to AWS.

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

### Explanation
- boto3.resource("s3")
    - Uses the resource interface, which provides a higher level, object oriented way to work with S3 compared to the client.

- bucket = s3.Bucket(BUCKET_NAME)
    - Creates a reference to the specific S3 bucket so actions can be performed on it.

- bucket.objects.all().delete()
    - Removes all objects inside the bucket.
    - This step is required because AWS does not allow deletion of a non empty bucket.

- bucket.delete()
    - Deletes the bucket itself after it has been emptied.

- print("Bucket deleted")
    - Confirms that the bucket removal process has completed.
  
---

## Summary

This task demonstrated how Python and boto3 can be used to manage AWS S3 resources in a simple, repeatable, and automated way. These scripts form the foundation for more advanced AWS automation tasks.
