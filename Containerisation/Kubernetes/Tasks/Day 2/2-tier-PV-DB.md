# Task: Create 2-tier deployment with PV for database

my MongoDB pod stored data inside the container filesystem. That works until the pod is deleted or recreated, at which point the data can be lost.

By introducing PersistentVolume (PV) and PersistentVolumeClaim (PVC)

1. PersistentVolume (PV) to represent storage available in the cluster
2. PersistentVolumeClaim (PVC) to request that storage
3. MongoDB Deployment that mounts the PVC into /data/db (Mongo’s data directory)

## Step 1: Created the PV and PVC files 

1. PersistentVolume mongo-pv.yml - This creates a PV with a small amount of storage so I do not over allocate disk space.
   1. `storage` - 1Gi keeps it small and suitable
   2. `accessmode` - ReadWriteOnce matches Mongo’s typical single pod setup
   3. `hostPath` is a local storage method used for local cluster environments
2. PersistentVolumeClaim mongo-pvc.yml - This PVC requests storage from the PV.
   1. The claim requests 1Gi, which matches the PV size
   2. Once the claim is satisfied, the PV and PVC become Bound
   3. The Deployment then mounts the claim into the Mongo pod
3. MongoDB Deployment with Volume Mount mongo-deployment.yml
   1. `mountPath: /data/db` is where Mongo stores its database files
   2. The PVC is attached via `claimName: mongo-pvc`

## Step 2: Deployment 

1. Apply PV and PVC - the storage resources must be applied first because the Mongo deployment depends on them.
`kubectl apply -f mongo-pv.yml`
`kubectl apply -f mongo-pvc.yml`

2. Confirm PV and PVC are Bound - once these two commands are runned we should see a status for both showing Bound. If an error appears that means Mongo cannot use persistent storage.
`kubectl get pv`
`kubectl get pvc`

3. Deploy MongoDB - Now that the mongodb-deployment file has been updated with the PVC attached we can now check everything is working correctly. `kubectl apply -f mongo-deployment.yml`
   1. `kubectl get pods` check mongo is running 
   
4. Manually seeding the database to confirm the posts page was working and showing data. As this was going to be. important in making sure the next part works

## Step 3: Deleting the MongoDB pod and Checking the new pod was created

1. `kubectl delete pod -l app=mongo` - The Mongo pod was deleted and then about 45 seconds later when i checked a new Mongo pod was created
   1. This happened because the Deployment is enforcing replicas: 1.
2. I then confirmed with the new pod created that the post page was displaying the same data as this confirmed: 
   1. MongoDB is writing to the PVC mounted at /data/db
   2. The PVC is backed by the PV
   3. The storage is persisting across pod recreation

## Step 4: Removing PV 
To avoid leaving PVs behind (because they persist even when pods are deleted), I removed them when finished.

`kubectl delete -f mongo-deployment.yml`
`kubectl delete -f mongo-pvc.yml`
`kubectl delete -f mongo-pv.yml`

