# Task: Delete K8s deployments and services

task was to delete the nginx-deployment Deployment and the nginx-svc Service using the original YAML files, and then verify that all related resources such as ReplicaSets and Pods were also removed.

## Step 1 – Delete the Deployment Using the YAML File and Delete the Service Using the YAML File

I used `kubectl delete -f nginx-deployment.yml` this removed the Deployment object from the cluster and `kubectl delete -f nginx-service.yml` removed the Service that was exposing the Nginx pods via NodePort.

## Step 2 – Verify the Deployment, Service and ReplicaSet Was Deleted

The commands I ran were: 
1. `kubectl get deployments` - confirmed that nginx-deployment no longer appeared in the list.
2. `kubectl get svc` - verified that nginx-svc no longer appeared in the list.
3. `kubectl get replicasets` - confirmed that there were no ReplicaSets related to nginx.
4. `kubectl get pods` - confirmed that all pods created by the Deployment were automatically deleted.


When I deleted the Deployment:
 
	•	The Deployment object was removed.
	•	The associated ReplicaSet was automatically deleted.
	•	All Pods managed by that ReplicaSet were deleted.

When I deleted the Service:

	•	The NodePort exposure was removed.
	•	Traffic to port 30001 was no longer routed.
	•	The Service object was removed from the cluster.