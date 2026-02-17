
# Task: Run and pull your first image

## Everything I learned from this task

• Docker has built in help via docker --help and command specific help like docker images --help
• docker images shows what images are stored locally
• docker run hello-world will:
• Pull the image automatically if it is not present
• Create a container from the image
• Run the container and print output
• Exit when the task is complete
• Docker images are cached locally after the first download
• Running the same image again does not require downloading again unless the image is missing or removed
• Each docker run creates a new container instance, even when using the same image


# Task: Run nginx web server in a Docker container

1. Docker images vs containers
   
	•	An image is a template
	•	A container is a running instance of that image
	•	You can create multiple containers from the same image

2. Pulling images

	•	docker pull nginx downloads images from Docker Hub
	•	Docker only downloads an image once unless removed

3. Running containers
   
	•	docker run creates and starts a container
	•	The -d flag runs it in the background
	•	The --name flag makes management easier

4. Port mapping
   
	•	-p hostPort:containerPort
	•	-p 80:80 maps local port 80 to port 80 inside the container
	•	This allows you to access the service through your browser
	```docker run -d -p 80:80 --name my-nginx nginx```

Without port mapping, the service runs but is not accessible from your machine.

5. Monitoring containers
   
	•	docker ps shows running containers
	•	docker ps -a shows all containers
	•	You must stop containers when finished to free resources

6. Containers are isolated
7. 
	•	nginx runs inside an isolated environment
	•	It does not install nginx directly on your system
	•	When the container stops, nginx stops with it

## What I learned

In this task I:
	•	Pulled the nginx image from Docker Hub
	•	Ran it as a detached container
	•	Mapped port 80 so it could be accessed locally
	•	Verified it was running using docker ps
	•	Confirmed functionality in a web browser
	•	Stopped the container safely


# Task: Remove a container

1. Docker protects running containers

By default, Docker does not allow removal of running containers to prevent accidental data loss or service interruption.

2. Difference between stop and remove
   
	•	`docker stop` → Stops a running container
	•	`docker rm` → Removes a stopped container
	•	`docker rm -f` → Stops and removes a running container in one command

3. The force flag (-f)

The -f flag:

	•	Forces removal
	•	Automatically stops the container first
	•	Is useful for quick cleanup during development

However, in production environments, forcing removal without understanding impact could interrupt live services.

4. Checking container status
   
	•	`docker ps` → Shows running containers
	•	`docker ps -a` → Shows all containers (running and stopped)

After removal, the container disappears from both lists.

## What I learned

In this task I:

	•	Restarted an nginx container
	•	Attempted to remove it while running and observed the protection error
	•	Identified the -f flag as the solution
	•	Successfully removed a running container
	•	Verified its removal using Docker status commands

This task reinforced understanding of:

	•	Container lifecycle management
	•	Safe deletion practices
	•	The importance of Docker command options
	•	The distinction between stopping and removing containers


# Task: Modify our nginx default page in our running container

1. Re run the nginx container exposed on port 80
2. Check the default webpage
   1. http://localhost
3. Access the shell of the running container
   1. `docker exec -it my-nginx bash`
   
   Breakdown:

	•	docker exec → Run a command inside a running container
	•	-it → Interactive terminal
	•	my-nginx → Container name
	•	bash → Open bash shell
4. Run update and upgrade inside the container
5. Sudo won't work. Why?
   
	•	Containers often run as root
	•	Minimal images do not include sudo
	
	You must use `apt install sudo -y` 
6. Find the default nginx file
   1. cd /usr/share/nginx/html
7. Edit index.html with nano
   1. Had to install nano first `apt install nano -y`
8. Modify the HTML and then checked in my browser 
   1. Add image

## What I learned

In this task I:

	•	Restarted an nginx container
	•	Accessed its shell
	•	Fixed TTY issues using winpty
	•	Installed missing tools
	•	Navigated to nginx’s default HTML file
	•	Modified index.html
	•	Observed live changes in the browser

This task reinforced understanding of:

	•	Container lifecycle
	•	Interactive debugging
	•	Package management inside containers
	•	The temporary nature of container changes
	•	The importance of automation over manual changes 

# Task: Run a different container on different port

1. Host port conflicts

Only one service can bind to a specific host port at a time.

If one container uses: `-p 80:80` and another cannot use also use: `-p 80:80`

2. Container port vs Host port

Container ports can be identical across containers.

For example Container A can use:  `-p 80:80`  and  Container B can use: `-p 80:80`
Both use port 80 inside the container, but different ports externally.

3. Docker networking concept

Docker performs port forwarding: `Local machine:90 → Container:80`

This allows multiple services to run on one machine without conflict.

4. Cleaning up failed containers

Even when a container fails to start, Docker may create it.

Check with - `docker ps -a`
Remove with - `docker rm container_name`

## What I learned

In this task I:

	•	Attempted to run a second container on an already used port
	•	Observed the port allocation error
	•	Understood why Docker blocks duplicate host ports
	•	Removed the failed container
	•	Successfully ran the new container on port 90
	•	Verified both containers running independently

This reinforced understanding of:

	•	Port mapping
	•	Host vs container networking
	•	Docker container lifecycle
	•	Managing multiple running services

# Task: Push host-custom-static-webpage Container Image to Docker Hub

1. Containers vs Images

	•	Containers are running instances
	•	Images are templates
	•	docker commit turns a container into an image

Commit the running container to a new image

`docker commit my-nginx sunder09/host-custom-static-webpage:latest`

	•	docker commit → Creates a new image from a running container
	•	my-nginx → The container name
	•	yourdockerhubusername/host-custom-static-webpage → Repository name
	•	:latest → Tag

1. Docker Hub Naming Convention

Images must be tagged with: `username/repository:v1` otherwise the push will fail

3. Docker Login Required

You must authenticate before pushing images.

4. Pushing to Docker Hub
	•	docker push uploads image layers
	•	Docker only uploads new layers
	•	The image becomes accessible anywhere

5. Pulling Automatically

When running: `docker run sunder09/imagename`
If the image does not exist locally:
	•	Docker automatically pulls it from Docker Hub

1. Port Mapping Flexibility

We used port 8080 this time to avoid conflict with existing containers.

Multiple containers can:
	•	Use port 80 internally
	•	Use different external host ports

## What I learned

In this task I:

	•	Created a custom image from a running modified nginx container
	•	Tagged it correctly using Docker Hub naming conventions
	•	Logged into Docker Hub
	•	Pushed the image successfully
	•	Pulled and ran the image using my Docker Hub username
	•	Verified the modified webpage works in the browser

This demonstrates understanding of:

	•	Docker image lifecycle
	•	Image versioning and tagging
	•	Container to image conversion
	•	Remote image repositories
	•	Deployment portability

# Task: Automate docker image creation using a Dockerfile
Objective

In this task, I automated the process of modifying the default nginx webpage by using a Dockerfile instead of manually editing a running container. I then built the image, pushed it to Docker Hub, removed it locally, and verified it could be pulled again.

1. Created a New Working Directory

mkdir tech517-mod-nginx-dockerfile
cd tech517-mod-nginx-dockerfile

This ensured my Dockerfile and HTML file were organised in a dedicated build context.


2. Created a Custom index.html

I created a custom HTML file to replace the default nginx page: 

3. Created a Dockerfile

I created a file named exactly Dockerfile (capital D, no extension)

Contents within the file"
```
FROM nginx:latest

COPY index.html /usr/share/nginx/html/index.html
```

What this does:

• FROM nginx:latest
Uses the official nginx image as the base.

• COPY index.html /usr/share/nginx/html/index.html
Replaces nginx’s default homepage with my custom HTML file.

This removes the need to manually modify containers.

4. Built the Custom Image

Inside the folder, i ran - `docker build -t tech517-nginx-auto-change:v1 .`

	• The . tells Docker to use the current directory as the build context.
	• The -t flag tags the image.

5. Ran the Container

I ran the container on port 8081:

`docker run -d -p 8081:80 --name tech517-nginx-auto-change tech517-nginx-auto-change:v1`

	• -d runs in detached mode.
	• -p 8081:80 maps local port 8081 to container port 80.
	• --name assigns a container name.
	• The final argument is the image name.

I then ran `docker ps` to confirm it was running then i went to go check in my browser 

6. Tagged the Image for Docker Hub
   
To push to Docker Hub, I tagged the image with my username: `docker tag tech517-nginx-auto-change:v1 sunder09/tech517-nginx-auto-change:v1`

As docker requires this format - username/repository:tag

7. Pushed the Image to Docker Hub

`docker push sunder09/tech517-nginx-auto-change:v1`

This uploaded my image layers to Docker Hub.


8. Removed Local Copy of the Image

To prove the image could be pulled from Docker Hub, I removed the local copy:
`docker rmi tech517-nginx-auto-change:v1
docker rmi sunder09/tech517-nginx-auto-change:v1`


9. Re-Ran the Container (Forcing a Pull)

Since the image no longer existed locally, I ran:
`docker run -d -p 8081:80 --name tech517-nginx-auto-change sunder09/tech517-nginx-auto-change:v1`

Docker automatically:
	•	Detected the image was missing locally
	•	Pulled it from Docker Hub
	•	Created and ran the container

## What I Learned
	•	A Dockerfile automates container customisation.
	•	FROM defines the base image.
	•	COPY can override files inside the container.
	•	docker build creates a reproducible image.
	•	Images must be tagged correctly to push to Docker Hub.
	•	Docker automatically pulls images if they do not exist locally.
	•	Containers are disposable, but images are reusable and portable.
	•	Automation using Dockerfiles is significantly better than manually modifying running containers.
