# Displaying an Image from AWS S3 on the Sparta Test App

## Task Overview

In this task, the goal was to display an image stored in **AWS S3** on the **Sparta Test App front page**.  
This demonstrates how cloud object storage (S3) can be integrated into an application running on an EC2 instance.

The app was run **without a database**, focusing purely on:
- AWS CLI usage
- S3 storage
- Public object access
- Frontend integration

---

## Architecture Used

- **EC2 App VM**
  - Node.js Sparta Test App
  - Nginx reverse proxy
  - PM2 process manager
- **AWS S3**
  - Stores static image (cat image)
  - Public access enabled for the image

---

## Step 1: Prepare the App VM

A fresh App VM was created using an existing AMI or User Data script to ensure:
- Node.js is installed
- App dependencies are installed
- The Sparta app runs correctly on the front page

The app was confirmed working before making any changes.

---

## Step 2: Install AWS CLI on the App VM

On the App VM:

```bash
sudo apt update -y
sudo apt upgrade -y
sudo apt install python3-pip -y
pip3 install awscli
```

Verify installation:

```bash
aws --version
```

---

## Step 3: Configure AWS CLI Authentication

```bash
aws configure
```

Entered:
- AWS Access Key
- AWS Secret Key
- Default region: `eu-west-1`
- Output format: `json`

Verified access:

```bash
aws s3 ls
```

---

## Step 4: Create an S3 Bucket for Images

```bash
aws s3 mb s3://tech517-alex-sparta-app-images --region eu-west-1
```

Note:
- S3 bucket names must be **lowercase**
- Bucket names are **globally unique**

---

## Step 5: Download a Cat Image to the VM

```bash
curl -o downloadedcat.jpg https://placekitten.com/400/400
```

Verified file:

```bash
ls -l downloadedcat.jpg
```

---

## Step 6: Upload the Image to S3

```bash
aws s3 cp downloadedcat.jpg s3://tech517-alex-sparta-app-images/uploadedcat.jpg
```

Confirm upload:

```bash
aws s3 ls s3://tech517-alex-sparta-app-images
```

---

## Step 7: Make the Image Public (AWS Console)

1. Open **AWS S3 Console**
2. Select bucket: `tech517-alex-sparta-app-images`
3. Click `uploadedcat.jpg`
4. Go to **Permissions**
5. Enable **public access**
6. Save changes

This allows the image to be accessed by a web browser.

---

## Step 8: Obtain the Public Object URL

Copied the **Object URL** from S3:

```text
https://tech517-alex-sparta-app-images.s3.eu-west-1.amazonaws.com/uploadedcat.jpg
```

---

## Step 9: Update the Sparta App Front Page

Edited the front page template:

```bash
nano ~/tech517-sparta-app/app/views/index.ejs
```

Replaced the local image with the S3-hosted image:

```html
<img src="https://tech517-alex-sparta-app-images.s3.eu-west-1.amazonaws.com/uploadedcat.jpg" 
     alt="Cat from S3" 
     style="max-width: 400px;">
```

---

## Step 10: Restart the App

```bash
pm2 restart sparta-app
sudo systemctl restart nginx
```

---

## Result

- Sparta Test App loads correctly
- Cat image is displayed on the front page
- Image is hosted in AWS S3
- No database required
- App successfully integrates cloud object storage

---

## Key Concepts Demonstrated

- AWS CLI usage on EC2
- S3 bucket and object management
- Public vs private S3 access
- Serving static assets from S3
- Decoupling application and static content storage

---

## Deliverable

Screenshot of:
- Sparta Test App front page
- Cat image visible
- Image sourced from AWS S3

Message:
> **frontpage showing cat image stored in S3 storage**
