# Task: Create Nginx deployment only (Kubernetes)

For this task I needed to create a Kubernetes Deployment that runs an Nginx container image with three replicas. The focus was only on the Deployment object, not exposing it publicly.

I created a Kubernetes Deployment called nginx-deployment with:

	•	3 replicas (so Kubernetes always keeps 3 pods running)
	•	A label of app: nginx
	•	A container called nginx
	•	The Docker image daraymonsta/nginx-257:dreamteam
	•	Container port 80

## Step 1: Create the YAML file
Need to add snippet 

## Step 2: Create the Deployment in Kubernetes

`kubectl apply -f nginx-deploy.yml`

This created the Deployment and Kubernetes then automatically created:

	•	A ReplicaSet
	•	Three pods managed by that ReplicaSet

## Step 3: Check the Deployment, ReplicaSet, and Pods

### Deployment details

To confirm the Deployment exists - `kubectl get deployments`

### ReplicaSet details

To view the ReplicaSet created by the Deployment - `kubectl get rs`

### Pod details

To confirm I had three running pods - `kubectl get pods`

### One command to see all three

To see deployments, replicasets, and pods together - `kubectl get all`


## Step 4: Attempting to access the app in a browser

I tried to access the Deployment using localhost or ClusterIP, but I couldn’t reach it directly.

### Why it didn’t work

A Deployment by itself does not expose anything outside the cluster.

Kubernetes separates two responsibilities:

	• Deployments create and manage pods
	• Services expose pods to the network

Because I did not create a Service (ClusterIP, NodePort, LoadBalancer, or Ingress), there was no networking route that would allow me to open it in a browser.

So I documented that:

	• ClusterIP is internal only
	• localhost won’t work without a Service or port forward
	• The Deployment is running, but not publicly reachable