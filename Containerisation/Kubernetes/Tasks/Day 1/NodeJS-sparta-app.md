# Kubernetes Deployment – Sparta NodeJS App

## Part 1 - local-nodejs20-app-deploy

I deployed the Sparta NodeJS test app to Kubernetes with 3 replicas, exposed it using a NodePort Service, and confirmed I could reach the app in the browser.

### Deployment File – sparta-app-deployment.yml

This Deployment creates 3 replicas of the NodeJS app using the Docker image hosted on Docker Hub.

#### I set replicas to 3 to demonstrate:

• Kubernetes automatically maintains three running pods

• If one pod fails, Kubernetes recreates it

• The application can scale horizontally

#### Labels and Selector

1. The Deployment uses labels so the Service can correctly identify and route traffic to the pods.

2. The selector must match the pod template labels exactly.

3. If these do not match, the Service will not be able to send traffic to the application.

4. This is a critical concept in Kubernetes networking.


#### Container Configuration

The container:

• Pulls the image from Docker Hub
• Runs the Sparta app
• Exposes port 3000 internally

containerPort: 3000 does not expose the app externally.
It only informs Kubernetes which port the container listens on.

### Service File – sparta-app-service.yml

I used a NodePort Service so I could access the app from my browser.

I used type: NodePort because:
1. I needed external access for testing
2. It allows access through localhost
3. It exposes a port on the Kubernetes node

#### Port Configuration

1. port: 3000 → Service port
2. targetPort: 3000 → Container port
3. nodePort: 30002 → External port used in browser

This means I should access the application at: http://localhost:30002

### Commands

Similar to how commands have been used in previous tasks I applied them again. 

1. Apply the deployment and service
`kubectl apply -f sparta-app-deployment.yml`
`kubectl apply -f sparta-app-service.yml`

2. I used the `kubectl get all` to show deployment, pods, service and repliecast 
3. `kubectl get svc` - Confirm Service is exposing NodePort = sparta-app-svc  NodePort  3000:30002/TCP

## Part 2 - local-nodejs20-app-and-mongo-deploy

Deployed MongoDB inside Kubernetes so that:

1. The NodeJS app could connect to a database
2. The database runs internally only
3. It is not exposed publicly
4. The app connects using Kubernetes DNS

### MongoDB Deployment
Within the mongo-deployment.yml file I have added indentation to each line showing what happens. 

`kind: Deployment` - I used a Deployment rather than a Pod so that:
1. Automatic restart if Mongo crashes
2. Controlled scaling if needed
3. Managed lifecycle by Kubernetes

`replicas: 1`
1. This is a single-instance database setup
2. The task does not require a replica set
3. Running multiple Mongo instances without clustering would cause issues

`Container Configuration` -  Mongo:7.0 is choosen because
1. It is a maintained official image
2. It is compatible with the version used previously in Docker Compose
3. It avoids deprecated Mongo versions

`containerPort: 27017` - This exposes port 27017 inside the cluster.

### MongoDB Service

Within the mongo-service.yml file I have added indentation to each line showing what happens. 

`Service Type: ClusterIP` - I chose ClusterIP because:
1.	MongoDB should not be publicly accessible
2.	Only internal pods should connect to it
3.	It improves security

ClusterIP provides a stable internal endpoint inside the cluster.


When the file ran the service was created - `mongo-svc`

Kubernetes automatically creates internal DNS - `mongo-svc.default.svc.cluster.local` within the cluster I only needed `mongo-svc`

This allowed the app to connect using - `mongodb://mongo-svc:27017/posts`

## Commands 

1. I deployed MongoDB - `kubectl apply -f mongo-deployment.yml`
`kubectl apply -f mongo-service.yml`

2. I used the `kubectl get all` to show deployment, pods, service and repliecast 

### How the App Connects to Mongo

Inside the NodeJS Deployment, I added:

env:
  - name: DB_HOST
    
    value: "mongodb://mongo-svc:27017/posts"

Using the Service name instead of an IP ensures:
1.	The connection survives pod restarts
2.	The app works across multiple replicas
3.	Networking remains stable
4.	The app does not depend on dynamic pod IPs


