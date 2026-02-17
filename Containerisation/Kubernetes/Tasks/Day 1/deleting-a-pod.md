# Task: See what happens when we delete a pod

## Step 1: Listing the Running Pods

I checked which pods were currently running in my cluster - `kubectl get pods`

This showed me all the pods created by my nginx-deployment. I could see that I had three pods running, which matches the number of replicas defined in my Deployment.

## Step 2: Deleting One Pod

manually deleted one of the pods to see how Kubernetes would react - `kubectl delete pod nginx-deployment-67c68f6d64-5q4sz`

The terminal confimed this pod was removed out of the 3 pods

## Step 3: Immediately Checking the Pods Again

I reran `kubectl get pods`

What I noticed was that:

1. A brand new pod had been created.
2. The AGE of this new pod was only a few seconds.

Kubernetes immediately detected that the number of running pods was lower than the desired number of replicas.

## My understanding 

Deployment
→ manages a ReplicaSet
→ ReplicaSet manages the Pods

When I deleted a pod:

	•	The ReplicaSet detected that the number of pods dropped
	•	It created a new one automatically

This ensures high availability and reliability.

