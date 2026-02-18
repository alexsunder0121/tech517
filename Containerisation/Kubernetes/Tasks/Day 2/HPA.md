# Task: Use Horizontal Pod Autoscaler (HPA) to scale the app

This task was to configure a Horizontal Pod Autoscaler (HPA) to automatically scale the Sparta NodeJS application based on CPU usage.



## Step 1: Local cluster TLS Issue I had 

1. I had to add the flag by editing the deployemnt - `kubectl -n kube-system edit deployment metrics-server`
2. Find the container args section and add - `- --kubelet-insecure-tls`
3. Then restart the rollout - `kubectl rollout restart deployment metrics-server -n kube-system`
`kubectl rollout status deployment metrics-server -n kube-system`

I installed metrics server, but it cannot collect CPU data until it can successfully talk to the kubelet on each node. On local clusters the kubelet certs often do not validate the way metrics server expects, so without --kubelet-insecure-tls, it cannot scrape metrics and Kubernetes reports “Metrics API not available”.

## Step 2: Before configuring HPA

`kubectl top pods`
`kubectl top nodes`

If these commands return CPU and memory usage, HPA can function correctly.

## Step 3: CPU requests are required

HPA scales based on CPU utilisation relative to the container’s requested CPU.

If no CPU request is defined, HPA cannot calculate utilisation properly.

Therefore, I updated the app container configuration to include:
```
resources:
  requests:
    cpu: 100m
    memory: 128Mi
  limits:
    cpu: 500m
    memory: 256Mi
```
* requests.cpu defines the baseline for utilisation calculation
* PA calculates: (current CPU usage) / (CPU request)

## Step 4: Creating the Horizontal Pod Autoscaler

`kubectl autoscale deployment sparta-app-deployment --cpu=50% --min=2 --max=10` - This configuration means:
1. Target CPU utilisation: 50%
2. Minimum replicas: 2
3. Maximum replicas: 10

To Confirm the HPA was created I used - `kubectl get hpa`
`kubectl describe hpa sparta-app-deployment`

The Output showed: 
`
cpu: 0%/50%
MINPODS: 2
MAXPODS: 10
REPLICAS: 2
`
1. HPA was controlling the deployment
2. It reduced replicas to the minimum of 2

## Step 5: Load Testing with Apache Bench

To trigger scaling, I performed load testing using Apache Bench. `sparta-app-svc   NodePort   3000:30002/TCP`

I ran - `ab -n 20000 -c 200 http://localhost:30002/`. This generated high concurrent traffic to increase CPU usage.

* While the load test was running, I monitored the HPA: ` kubectl get hpa -w`
  * I was looking for `cpu: 82%/50% REPLICAS: 2`
    * Average CPU usage was 82%
    * Target was 50%
    * HPA detected usage above threshold

* Shortly after, the HPA scaled the deployment: REPLICAS: 4
* I ran `kubectl get pods` which confirmed 4 pods were now running 
  
# Why CPU Dropped After Scaling

After scaling up, HPA showed:
`cpu: 0%/50%
REPLICAS: 4`

This happened because:
1. Load was now distributed across more pods
2. Average CPU per pod decreased
3. Utilisation fell below threshold

This demonstrates that HPA dynamically balances workload.



