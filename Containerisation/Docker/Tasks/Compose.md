# Task: Use Docker Compose to Run App and Database Containers

The goal of this task was to run the Sparta Test App and a MongoDB database together using Docker Compose.

The application depends on a database connection, so both containers must:
	•	Run at the same time
	•	Be networked together
	•	Share a defined environment variable for database connectivity


# Verifying Required Images

Before creating the Compose setup, I confirmed I had the required images:

Application Image
	•	sunder09/sparta-test-app:latest
	•	Previously built and pushed to Docker Hub

Database Image
	•	mongo:7.0
	•	Official MongoDB image from Docker Hub


# Creating the Docker Compose Setup

Inside this folder, I created docker-compose.yml.

```
services:
  mongo:
    image: mongo:7.0
    container_name: mongo
    ports:
      - "27017:27017"
    volumes:
      - mongo_data:/data/db

  app:
    image: sunder09/sparta-test-app:latest
    container_name: app
    ports:
      - "3000:3000"
    environment:
      DB_HOST: mongodb://mongo:27017/posts
    depends_on:
      - mongo
    restart: unless-stopped

volumes:
  mongo_data:
  ```

## Important Configuration Decisions

Mongo Service
	•	Uses official mongo:7.0 image
	•	Port 27017 mapped to host
	•	Persistent volume created (mongo_data)
	•	Ensures data survives container restarts

App Service
	•	Uses my Docker Hub image
	•	Port 3000 mapped to host using:
	•	Sets environment variable:

This is critical.

Because Docker Compose creates an internal network, the app can reach the database using the service name mongo as the hostname.

# Running the Containers

From inside the sparta-compose folder, I ran: `docker compose up -d`-

Then verified container status: `docker compose ps`

`0.0.0.0:3000->3000/tcp` This confirmed that port 3000 was correctly published to my host machine.

## Testing the Application

I used - `curl -I http://localhost:3000` This returned HTTP 200.

I then tested the posts route: `curl -I http://localhost:3000/posts`

The route responded correctly, but the page was empty. This confirmed:
	•	The app is connected
	•	Mongo is reachable
	•	The database exists
	•	No data has been seeded yet

# Debugging Issues I Encountered

During setup, I encountered several key issues:

Port 3000 was already Allocated. Another container was already using port 3000.

I identified the issue and then stopped and removed the conflicting container:

After cleaning up, Compose was able to publish port 3000 correctly.


# Manual database seeding (Docker Compose)

The goal of manual seeding was to populate MongoDB with test data so /posts would display content.

## Seeding the database manually

Because the seed script is part of the Node app codebase, I ran it inside the app container using docker compose exec.
`docker compose exec app node seeds/seed.js`

Output: 

	• Connected to database
	• Database cleared
	• Database seeded with 100 records
	• Database connection closed

I then checked in my browser to see now if the post page is showing the records instead of being blank. 

# Automatic Database Seeding Using Docker Compose

I wanted to automate the process so that the database would populate automatically when the containers start.

`docker compose exec app node seeds/seed.js`

## How I Implemented Automatic Seeding

I modified the app service inside my docker-compose.yml file by overriding the default container start command.

Instead of allowing the container to directly run npm start, I replaced the command with:

`command: >
  sh -c "
  sleep 5 &&
  node seeds/seed.js &&
  npm start
  "
  `

1. sh -c

Runs multiple shell commands inside the container.

2. sleep 5

Important!

The MongoDB container needs time to fully initialise before accepting connections.

Without this delay, the seed script may fail with connection errors.

The delay ensures:

	•	Mongo container is ready
	•	Network DNS inside Docker is available
	•	Database port is open

3. node seeds/seed.js

This runs the seed script automatically inside the container.

The script:

	•	Connects to MongoDB
	•	Clears the existing collection
	•	Inserts 100 records
	•	Closes the database connection

This is the same script I previously ran manually.

4. npm start

After seeding completes, the application starts normally.

## Testing the Automatic seeding

The previous container that was running manually had to be stopped and removed. 

I restarted everything again from the start and built the containers back up and running. 

Once compelted I tested in my browser to see if the database was working. 