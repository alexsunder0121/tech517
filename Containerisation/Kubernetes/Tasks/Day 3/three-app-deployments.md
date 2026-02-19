# Task: Deploy on three apps on one cloud instance running minikube

## First app deployment
Deploy an Nginx application on Minikube with:

1. 5 replicas
2. A NodePort service on port 30001
3. Expose it externally using Nginx installed on the EC2 instance
4. Access it via http://EC2_PUBLIC_IP

### Step 1 – Create the Deployment

I created a Kubernetes Deployment using the image - daraymonsta/nginx-257:dreamteam

The Deployment was configured with:
1. 5 replicas
2. Container port 80
3. Label: app: app1-nginx

I created the nginx-deployment file and used the following command `kubectl apply -f app1-nginx-deploy.yml`

Once the file was deployed I ran `kubectl get pods` which showed me confirmed all 5 replicas were running successfully.

### Step 2 – Create the NodePort Service

I created a Service of type NodePort.
	•	Service port: 80
	•	Target port: 80
	•	NodePort: 30001
	•	Selector: app: app1-nginx
I created the ngnix-service file and used the following command `kubectl apply -f app1-nginx-svc.yml`

I verified the file ran and was successful `kubectl get svc` which outputted - `80:30001/TCP`

This meant that:
1. Inside the cluster → port 80
2. Externally on the Minikube node → port 30001

### Step 3 – Test the NodePort Inside the EC2 Instance

1. I checked the Minikube IP - `minikube ip`
2. Then I tested the NodePort - curl -I http://192.168.49.2:30001
   1. This outputted HTTP/1.1 200 OK
3. This confirmed 
   1. The Service is correctly routing traffic
   2. The pods are responding
   3. The application is working inside the instance

### Step 4 – Install Nginx on the EC2 Host

Since the requirement was to expose the app on the EC2 instance IP

1. I installed Nginx on the EC2 instance: update, install, enable and start nginx
2. I checked the status of nginx `sudo systemctl status nginx`

### Step 5 – Configure Reverse Proxy

1. I had to edit the nginx file by removing the default block and I replaced it with 
`location / {
    proxy_pass http://192.168.49.2:30001;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}`

This tells Nginx: When someone visits the EC2 public IP on port 80
→ Forward traffic to Minikube NodePort 30001

2. I tested the configuration: `sudo nginx -t`
3. Restarted nginx `sudo systemctl restart nginx`

### Step 6 – Final Verification

1. I did a local test on the EC2 - curl -I http://127.0.0.1 which outputted HTTP/1.1 200 OK

2. Then tested from my laptop browser which loaded the image onto the nginx page

## Architecture Flow

Browser
→ EC2 Public IP (port 80)
→ Host Nginx reverse proxy
→ Minikube NodePort 30001
→ Kubernetes Service
→ One of 5 Nginx pods

## Second app deployment

Deploy a second application on Minikube with:
1. 2 replicas
2. Image: daraymonsta/tech201-nginx-auto:v1
3. Service type: LoadBalancer
4. Service port: 9000
5. NodePort: 30002
6. Use minikube tunnel to emulate a cloud load balancer
7. Expose externally via host Nginx on: http://EC2_PUBLIC_IP:9000

### Step 1 – Create the Deployment

1. Simialr to the first deployment I created the same file but changed the name, replicas to 2, container port 80. 
2. I verfied the number of pods were running `kubectl get pods -l app=app2-nginx`
3. This confirmed the application containers were running successfully.

### Step 2 – Create the LoadBalancer Service

1. I created a Service of type LoadBalancer with:
   1. Service port: 9000
   2. Target port: 80
   3. NodePort: 30002
   4. Selector: app: app2-nginx

2. I applied the file and checked it service once ran `kubectl get svc app2-nginx-svc`
   1. After this complted the EXTERNAL-IP was showing as pending 

3. This is expected because Minikube does not automatically create real cloud load balancers.

### Step 3 – Use minikube tunnel

1. To emulate a cloud load balancer, I ran - `sudo -E minikube tunnel`
   1. Creates network routes on the host
   2. Assigns an external IP to LoadBalancer services
   3. Allows LoadBalancer services to work locally

2. I than wanted to check after running the tunnel `kubectl get svc app2-nginx-svc` 
   1. the service then showed the EXTERNAL-IP 

3. This confirmed the LoadBalancer was functioning.

### Step 4 – Verify the Service Internally

1. First, I confirmed the Service had endpoints - `kubectl get endpoints app2-nginx-svc`
   1. This showed pod IPs, meaning traffic could reach the containers.

2. Then I tested using the Minikube IP and NodePort - curl -I http://$(minikube ip):30002
   1. Which I then recieved HTTP/1.1 200 OK

3. Overall this confirmed
   1. The pods were reachable
   2. The Service was routing traffic correctly
   3. The LoadBalancer was working internally

### Step 5 – Configure Host Nginx Reverse Proxy (Port 9000)

1. I configured host Nginx to listen on port 9000 and forward traffic to: http://192.168.49.2:30002
2. Creating the Nginx config: `sudo nano /etc/nginx/sites-available/app2-9000`
   1. server {
    listen 9000;
    server_name _;

    location / {
        proxy_pass http://192.168.49.2:30002;
        proxy_set_header Host $host;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
         }
    }`
3. I enabled this config file - `sudo ln -sf /etc/nginx/sites-available/app2-9000 /etc/nginx/sites-enabled/app2-9000`
4. I tested and restarted nginx 
5. Used the curl command to verify locally - `curl -I http://127.0.0.1:9000`
   1. I recieved HTTP/1.1 200 OK

### Step 6 – Configure AWS Security Group

The application initially did not load externally.

I then had to update the EC2 Security Group inbound rules to allow TCP port 9000 

Once I added this to my security group I reloaded my URL and the app displayed correctly 

## Architecture Flow

Browser
→ EC2 Public IP:9000
→ Host Nginx reverse proxy
→ Minikube Node IP (30002)
→ Kubernetes Service (LoadBalancer)
→ One of 2 pods

## Third app deployment 

Deploy a third application using the official hello-minikube example and:
1. Use a LoadBalancer service on port 8080
2. Use minikube tunnel to emulate a cloud load balancer
3. Expose the app externally via host Nginx at: http://EC2_PUBLIC_IP/hello

### Step 1 – Create the Deployment

1. I created a Deployment named:hello-minikube
2. Using the image - 
3. The container listens on:8080
4. I applied the file `kubectl apply -f app3-hello-deploy.yml` and checked if the number of pods running `kubectl get pods -l app=hello-minikube`

### Step 2 – Create the LoadBalancer Service

1. I created a Service of type: LoadBalancer
   1. Service port: 8080
   2. Target port: 8080
   3. NodePort auto-assigned
   
2. I applied the file - `kubectl apply -f app3-hello-svc.yml`

3. Then verified it - `kubectl get svc hello-minikube-svc`
   1. It showed - 8080:30444/TCP
      1. Service port = 8080
      2. NodePort = 30444

### Step 3 – Use minikube tunnel

1. Since this is a LoadBalancer service and we are running Minikube locally on EC2, I used: `sudo -E minikube tunnel`
   1. Emulates a cloud load balancer
   2. Assigns an external IP
   3. Allows LoadBalancer services to function correctly

2. After running the tunnel, kubectl get svc showed a LoadBalancer Ingress IP: 10.111.31.241

### Step 4 – Verify Service Internally

1. I verified the service endpoint - `kubectl get endpoints hello-minikube-svc`
2. tested using the NodePort - curl http://192.168.49.2:30444
3. Response: Hello, world!
            Version: 1.0.0
            Hostname: hello-minikube-666f7bdf44-mr6c2
This confirmed:

	• The pod is reachable
	• The service is routing traffic correctly
	• Kubernetes networking is working

### Step 5 – Configure Host Nginx Reverse Proxy

I modified the existing Nginx config to include:
```
location = /hello {
    return 301 /hello/;
}

location /hello/ {
    rewrite ^/hello/?(.*)$ /$1 break;
    proxy_pass http://10.111.31.241:8080/;
    proxy_set_header Host $host;
    proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
}
```
1. I proxied to the LoadBalancer IP (10.111.31.241)
2. Used port 8080
3. Included trailing slash in proxy_pass

I then tested and restarted nginx

### Step 6 – Final Verification

