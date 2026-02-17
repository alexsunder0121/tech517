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
* Container
  * Not an object in Kubernetes
  * It is used within a pod (which is a kubernetes object)
  
* Pod
  * A group of one or more containers
  * Smallest deployable object in Kubernetes
  * Going to share storage and network resources
  * Executed on a worker node
  * Specifies how to run the containers
  * Has an internal IP address
  * Are Ephemral - you can lose data when a pod is terminated or destroyed

* Service
  * A way to:
    * Expose your application and
    * Connect your pods 
  * Labels and selectors are used to match a service to app's pods 

* Volume
  * A way to persist the storage of data of your pods 

* ConfigMap
  * Key-value database to store the configuration

* Secret
  * A way to store sensitive information such as usernames, passwords, SSH keys
  * They are only base64 encoded, not encrypted 

* Namespace 
  * A way to logically group resources for an application 
  * If not specified, your resources will go into the `default` namespace

* ReplicaSet
    * Replicates or makes a certain number of identical pods 
    * Usually you don't create one directly (or creating one on it's own), you create a Deployment which creates the ReplicaSet 

* Deployment 
  * Used to deploy a ReplicaSet 
  * In this way, the Deployment doesn't directly deal with the pods 

## How to mitigate security concerns with containers

* Use a Maintained Container images 
* Use automatic vulnerability scanning on container registries 
* Use own security scanning tool on your container images 
* NEVER run containers with root priviliges 
* Monitor & Log container activity 

## Maintained images
 
* What are they
  * A docker image that is regularly updated and managed by a maintainer 
  * Usually the maintainer is an organisation, a community, or an individual 
    * E.g. Canonical maintain Ubunutu images 
  * Designed to give us a reliable, secure and up-to-date foundation for building and running our applications
  
* Pros and cons of using maintained images for your base container images
  * Pros 
    * Better security, as they are regularly patched 
    * Better stability 
    * More support and documentation 
    * Usually they would adhere to best practices 
    * May be streamlined to performance or small image size 

  * Cons
    * Dependent on the schedule of the maintaines for updates & patches 
    * 