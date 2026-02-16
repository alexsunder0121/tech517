# Intro to Kubernetes

## Why is Kubernetes needed
* Manage container workloads, especially scaling

## Benefits of Kubernetes
* Orchestrate/Schedule and Managing containers at scale
* Open-source
* Can run anywhere, examples:  
  * on-premises
  * private data center
  * public cloud
  * in embedded hardware like Raspberry Pi devices
* Self-healing
* Autoscaling
* Load balancing 
* Rolling updates and rollbacks (while an application is in use)
* Define the desire state of an application (e.g. how many copies of a container can be runned and have codified)
* Benefits over on monolith? No single point to failure (usually, unless you run your master + worker nodes on the same machine)

## Success stories

* 

## Kubernetes architecture (include a diagram)
 
## The cluster setup
* What is a cluster 
  * Made up of at least one Kubernetes master node
  * Must have at least one worker node
  * Can be multi-node (multiple workers) on single node (one worker node)
  * Single node is okay for dev/testing enviornments - can use Minikube

* Master vs worker nodes
  * Master node/components and worker nodes are kept seperate 
  * With AKS...
    * Azure take care of running master node ('primary server)
    * Do not charge for the master node
    * On VM will run for each worker node (this is what you pay for)
  * With AWS Elastic Kubernetes Service (EKS) or Google Kurbenetes Engine (GKE)
  * Wtih Minikube:
    * Can run the master and worker node on a single VM

* What is a master node?
  * Runs, Control plane components, such as API server, etcd, scheduler, controller manager
  * "Controler" which manages everything, controls the worker nodes (and the pods and containers within the pods)
  * Works on the "control plane"
  * How many are needed for production?
    * If setting up your own, min of 3
    * On AKS, Azure manages the control plane - it make sure it has high availability 

* What is a worker node?
* Often just called nodes
* This is your containers will be deployed & run 
* Work on the "data plane" because they run your applications


* Pros and cons of using managed service vs launching your own
  * Benefits on using a managed service 
    * Less experts needed
    * security - because you can control access using IAM
    * Save time 
    * Focus 
  * Downside 
    * You will pay more more on EKS and GKE for your primary server


* Control plane vs data plane

> see diagram


  * Control Plane Components (in blue)
    * API server
      * Central hub for all interactions with Kubernetes 
      * Only component which directly interacts with etcd
    * Etcd
      * Store/records the entire state of the Kubernetes cluster 
      * Key-value store 
      * Provides configuration data to control plane components
      * Important to backup etcd in case of disaster 
    * Controler Manager
      * Monitors for changes in the cluster, when detects changes need to be made it will take action
    * Schedular 
      * Specifies where to allocate resources

  * Data plane components (in green)
    * Kublet - connects directly to API server (on the control plane):
    * Recieves instructions from the API server 
    * Reports the status of pods and the node to API server
  * Kube-proxy
    * Configure/updates network rules on the node so that network routing is always in sync with the current state of the cluster
 
## Kubernetes objects
* The most common ones e.g. Deployments, ReplicaSets, Pods
* What does it mean a pod is "ephemeral"
 
## How to mitigate security concerns with containers
 
## Maintained images
 
* What are they
* Pros and cons of using maintained images for your base container images