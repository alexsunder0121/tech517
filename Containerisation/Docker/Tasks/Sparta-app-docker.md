# Task: Run Sparta test app in a container (Node.js v20)

I containerised the Sparta test app (front page only) using Node.js v20 and ran it on port 3000. I then built the image locally, pushed it to Docker Hub, and verified I could pull a fresh copy and run it again.

1. Creating a Dedicated Project Folder

Because Docker expects one Dockerfile per project directory, I created a new folder specifically for this task.

I then added over the app folder into the project folder

2. Writing the Dockerfile

I created a Dockerfile inside the sparta-app-docker directory.

The purpose of the Dockerfile is to define:

	•	The base image
	•	The working directory
	•	How dependencies are installed
	•	Which port the container exposes
	•	How the application starts

Inside the Dockerfile I added this into it:

-Use official Node.js 20 Alpine image
FROM node:20-alpine

-Metadata label
LABEL maintainer="Alex Sunder"

-Set working directory inside container
WORKDIR /usr/src/app

-Copy entire application into container
COPY app .

-Install dependencies
RUN npm install

-Expose application port
EXPOSE 3000

-Start the application
CMD ["npm", "start"]

3. Building the Docker Image

I first began creating the image - `docker build -t sunder09/sparta-test-app:latest .`

	• Builds the image using the Dockerfile in the current directory
	• Tags it with my Docker Hub username
	• Applies the latest tag

Docker downloaded the Node 20 Alpine base image, installed dependencies, and created a new container image layer by layer.

4. Running the Container

Once the image was built, I then ran the container - `docker run -d -p 3000:3000 --name sparta-test sunder09/sparta-test-app`

	• -d runs the container in detached mode
	• -p 3000:3000 maps host port 3000 to container port 3000
	• --name makes the container easier to manage
	• The final argument specifies the image

5. Pushing the Image to Docker Hub

`docker push sunder09/sparta-test-app:latest`

Docker uploaded only new layers, as unchanged layers are cached.

This made the image available remotely.

6. Forcing Docker to Pull a Fresh Image

To verify the image works independently of my local cache, I removed the local image - `docker rmi sunder09/sparta-test-app:latest`

`docker run -d -p 3000:3000 sunder09/sparta-test-app:latest`
Docker automatically pulled the image from Docker Hub and ran it successfully.

	• The image is portable
	• It works without relying on local build cache
	• It can be deployed anywhere
