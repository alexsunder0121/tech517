# Task: Get a NodePort service running

The goal of this task was to expose my Nginx deployment using a Kubernetes Service of type NodePort so that I could access it in my browser via localhost:30001.

## Step 1: Restarting my Nginx Deployment

I reapplied the cluster - `kubectl apply -f nginx-deployment.yml` if wasn't previously created. But for myself I used `kubectl get pods` to check the pods were running

## Step 2 – Create the NodePort Service

I created the service file: 

	•	Was of type NodePort
	•	Used port 80
	•	Targeted port 80 on the container
	•	Exposed nodePort 30001
	•	Selected pods with the label app: nginx

Once the file was created I then applied the service - `kubectl apply -f nginx-service.yml`

## Step 3 – Verify the Service

To check the service was created I used - `kubectl get svc` 
This outputted - `80:30001/TCP`. This confirmed that Kubernetes mapped: Cluster Port 80 → NodePort 30001

## Step 4 – Confirm the Service Is Connected to the Pod

I ran - `kubectl describe svc nginx-svc` 
Under Endpoints, I checked that it was NOT empty.

If Endpoints is empty, it means the Service selector does not match the pod labels.

## Step 5 – Test in the Browser

http://localhost:30001 - If everything was configured correctly, I saw the Nginx welcome page.



