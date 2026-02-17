# Task: Increase replicas with no downtime

## Method 1 – Edit the Deployment in Real Time

increase the number of replicas in my nginx-deployment without deleting and recreating the deployment. I wanted to confirm that Kubernetes can scale pods in real time without causing downtime.

### Step 1– Edit the Deployment Directly in the Cluster

 checked how many replicas were currently running - `kubectl get deployment`

 To modify the deployment without touching my YAML file, I used - `kubectl edit deployment nginx-deployment`

 Inside the file, I located the replicas field and changed it from 3 to 4

### Step 2 – Verify the New Replica Was Created

after saving the change, I checked the pods - `kubectl get pods`

1. A new pod was created.
2. Its AGE was only a few seconds.
3. The existing pods were not deleted.

Then I reran `kubectl get deployment` and it show me 4/4 pods

## Method 2 - Apply a modified deployment file

increase the number of replicas in my nginx-deployment by modifying the original deployment YAML file and reapplying it, rather than editing the live configuration directly in the cluster.

### Step 1 – Edit the Deployment YAML File

Inside my ngnix deployment file I changed replicas from 3 to 5 

### Step 2 – Apply the Updated Configuration

apply the changes without deleting the deployment - `kubectl apply -f nginx-deployment.yml`

Once the output confirmed the file was configured this indicated that Kubernetes updated the existing deployment rather than recreating it

### Step 3 – Verify the Replica Count Increased

confirm the scaling was successful - `kubectl get deployment`

The output showed - `nginx-deployment   5/5`

I also used `kubectl get pods` which displayed 5 pods 

## Method 3 – Use the scale Command

increase the number of replicas in my nginx-deployment using the kubectl scale command, without modifying the YAML file or editing the deployment directly.

### Step 1 – Scale the Deployment

To increase the number of replicas from 5 to 6, I ran - `kubectl scale deployment nginx-deployment --replicas=6`

The output confirmed - `deployment.apps/nginx-deployment scaled`

### Step 2 – Verify the Change

confirm that the scaling was successfu - `kubectl get deployment` this then outputted `nginx-deployment   6/6`

Using `kubectl get pods` showed me that:

1. A new pod was created.
2. Its AGE was only a few seconds.
3. The existing pods were not restarted or deleted.
