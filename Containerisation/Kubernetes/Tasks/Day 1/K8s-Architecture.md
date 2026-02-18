# Kubernetes Architecture – Sparta NodeJS App with MongoDB

This diagram represents how traffic flows through the Kubernetes cluster and how each component interacts.

We can break it down into three layers:
1.	External Access Layer
2.	Application Layer
3.	Database Layer


1️⃣ External Access Layer

Browser → localhost:30002

This represents the user accessing the application through a browser.

Why 30002?

Because:
	•	The Service type is NodePort
	•	NodePorts must be between 30000–32767
	•	We configured nodePort: 30002

So traffic enters the cluster through that port.

⸻

NodePort Service – sparta-app-svc

This is the entry point into Kubernetes.

It performs two important functions:
	1.	Exposes the app externally
	2.	Load balances traffic across multiple pods

It maps:
	•	nodePort 30002 → port 3000 → targetPort 3000

This means:

Browser → NodePort → app pods

Without this Service, the app would not be reachable from outside the cluster.

⸻

2️⃣ Application Layer

Deployment

The Deployment manages the application workload.

In the diagram, it contains:
	•	A ReplicaSet
	•	3 Pods

⸻

ReplicaSet

The ReplicaSet ensures:
	•	Exactly 3 replicas are running
	•	If a pod crashes, a new one is created automatically

This is Kubernetes self-healing.

⸻

Pods (3 replicas)

Each pod:
	•	Runs the Sparta NodeJS container
	•	Exposes port 3000 internally
	•	Has the environment variable:
    
Because there are 3 replicas:
	•	Traffic is distributed across them
	•	The system is more resilient
	•	The app can scale horizontally

⸻

3️⃣ Database Layer

ClusterIP Service – mongo-svc

This Service is internal only.

It:
	•	Provides stable DNS name: mongo-svc
	•	Routes traffic to the MongoDB pod
	•	Is not accessible externally

This is important for security.

Only the app pods can access it.

⸻

MongoDB Pod

This is a single replica database.

It:
	•	Runs mongo:7.0
	•	Listens on port 27017
	•	Receives traffic only from within the cluster

It is NOT exposed to the browser.