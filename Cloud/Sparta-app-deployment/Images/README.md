# Creating VM Images for the App and Database

## Purpose of Creating Images

After manually deploying and testing the Sparta Node.js application and MongoDB database, VM images were created to allow the environment to be reused, rebuilt quickly, and deployed consistently.

Creating images allows:

•Faster VM creation without repeating manual setup

•Consistent environments for testing and assessment

•Reduced configuration errors compared to manual installs

•A more production like deployment approach

Separate images were created for:

•Database VM (MongoDB image)

•Application VM (Node.js + Nginx image)

⸻

## Creating the Database VM Image

### Steps Taken
1.	A fresh Ubuntu 22.04 VM was created for MongoDB
2.	MongoDB 7 was installed and configured
3.	MongoDB was configured to listen on all interfaces by setting:
4.	MongoDB was started and enabled to run on boot:
5.	The database was tested to confirm it was running and listening on port 27017
6.	Once confirmed working, an AMI image was created from this DB VM

Why No User Data Was Needed on the DB Image
	
	• The database configuration does not change between deployments

	•MongoDB does not depend on the App VM

	•No dynamic values (such as IPs) are required at startup

	•The DB image is already fully configured and ready to accept connections

Because of this, the DB image can be reused without additional startup scripts.

## Creating the Application VM Image

Initial App VM Setup

Before creating the image, the App VM was configured with:

	•	Node.js v20
	•	Nginx
	•	PM2
	•	Sparta Node.js app code
	•	Nginx reverse proxy configuration

The app was verified to work:

	•	On port 3000 internally
	•	Via /posts without port 3000 using Nginx

Once confirmed, an image of the App VM was created.

## Why User Data Was Required for the App VM Image

Unlike the database, the application depends on the database’s private IP, which changes every time a new DB VM is created.

Because of this:

	• The database connection cannot be hard coded into the image
	• The app must be told at launch time where the database lives

This is why User Data was added only to the App VM, not the DB VM.


## What the App VM User Data Does

The User Data script on the App VM is responsible for:

	• Setting the DB_HOST environment variable using the current DB VM private IP
	• Ensuring the app runs with the correct database connection
	• Restarting the application process so it picks up the new DB_HOST value
	• Ensuring the app works correctly even when launched from an image


## Why User Data Is the Correct Approach

User Data is ideal here because:

	• It runs once on first boot
	• It allows dynamic configuration (DB IP changes)
	• It avoids rebuilding images every time the DB IP changes
	• It matches real world cloud deployment patterns

This approach ensures:

	• The App image remains reusable
	• The database connection is always correct
	• The /posts page works consistently

⸻

## Final Result

With images and User Data combined:

	• The DB VM image launches fully configured
	• The App VM image launches and automatically connects to the database
    • No manual SSH configuration is required after launch



