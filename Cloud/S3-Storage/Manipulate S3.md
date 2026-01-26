# AWS S3

## What is AWS S3

* Simple Storage Service 
* Used to store and retrieve any amount of data from anywhere you are connected to the internet 
* Easy to configure to host a static website on the cloud 
* Provides built-in redundancy 
  * Copy of the data is in a minimum of 3 Availabaility zones in the region 
* Can be accessed from AWS Console & AWS CLI 
* Equivalent to Azure Blob Storage
  
## How data stored?

* In Buckets (equialent to containers on Azure)


## Commands to use 

* List the buckets: `aws s3 ls`
* Make a bucket: 
  * ```aws s3 mb s3://tech517-Alex-first-bucket```
    Capital A isnt allowed i recieved an error

  * ```ubuntu@ip-172-31-45-6:~$ aws s3 mb s3://tech517-alex-first-bucket``` 
make_bucket: tech517-alex-first-bucket
* Upload a file to S3: 
  * Example: ```aws s3 cp <filename> s3://<bucket-name>```
  * Tester: ```aws s3 cp test.txt s3://tech517-alex-first-bucket```
* List files in a bucket: `aws s3 ls s3://tech517-alex-first-bucket`
* Download files from bucket: `aws s3 sync s3://tech517-alex-first-bucket .`
* Remove a single file from bucket: `aws s3 rm s3://<name of bucket>/<name of file to remove>`
  * Example: `aws s3 rm s3://tech517-alex-first-bucket/test.txt`
* Remove all files from the bucket: `aws s3 rm s3://tech517-alex-first-bucket`
  * MUST USE RECUSIVE OPTION⛔️: `aws s3 rm s3://tech517-alex-first-bucket --recursive` - DANGER!‼️ Will delete ALL files in the bucket without prompting 
* Remove bucket with files in it: `aws s3 rb s3://tech517-alex-first-bucket --force`DANGER!‼️ Will delete the bucket and ALL files in the bucket without prompting 
* 



# Using AWS CLI on an EC2 Instance (Beginner Guide)

This section explains how to install the AWS CLI on an EC2 instance, authenticate it with AWS, and use it to manage S3 storage. All steps are written at a beginner level.

---

## Installing Dependencies for AWS CLI on an EC2 Instance

Before installing the AWS CLI, the EC2 instance must be updated and have Python pip installed.

1. Update and upgrade the system packages:
```bash
sudo apt update -y
sudo apt upgrade -y
```

2. Install Python pip (required to install AWS CLI):

```sudo apt-get install python3-pip -y```

3.	Install AWS CLI using pip:

```sudo pip3 install awscli```

4.	Verify the installation:
```aws --version```

# #Authenticating Using AWS CLI

To allow the EC2 instance to interact with AWS services, the AWS CLI must be authenticated using access credentials.

1.	Run the AWS configuration command:
```aws configure```

2.	Enter the following when prompted:

	•	AWS Access Key ID: paste your access key
	•	AWS Secret Access Key: paste your secret key
	•	Default region name: eu-west-1
	•	Default output format: json

3.	Test authentication by listing S3 buckets:
```aws s3 ls```

## Manipulating S3 Storage Using AWS CLI

Once authenticated, the AWS CLI can be used to manage S3 buckets and files.

Create an S3 Bucket

Bucket names must be lowercase and globally unique.