# Monitoring, Alarm Management and AutoScaling

## Step 1: Create a CloudWatch Dashboard
1.	Logged into the AWS Management Console
2.	Navigated to CloudWatch
3.	Selected Dashboards
4.	Clicked Create dashboard
5.	Gave the dashboard a clear name (for example: sparta-app-dashboard)
6.	Selected widgets such as:

	• EC2 CPU Utilisation

	• Network In / Network Out

	• Disk Read / Write

7.	Selected the App VM EC2 instance as the data source

This dashboard allows real time visibility into how the VM behaves during load testing.

⸻

## Step 2: Enable Detailed Monitoring on the EC2 Instance
1.	Opened the EC2 console
2.	Selected the App VM
3.	Enabled Detailed Monitoring

Why this matters:
	
	• Standard monitoring updates every 5 minutes
	• Detailed monitoring updates every 1 minute
	• This makes spikes during testing visible on the dashboard

⸻

## Step 3: Prepare the App VM for Load Testing
1.	SSH into the App VM
2.	Changed into the correct user directory:
3. Install apache 
        ```
        sudo apt-get install apache2-utils
        ```
    
## Step 4: Load testing with Apache Bench 

Format for ab command:
```
ab -n 1000 -c 100 http://108.130.154.97/
```

- n = number of requests 
- c = number of requests to make at a time

Explanation:
	•	-n 100 = total number of requests
	•	-c 10 = number of concurrent users
	•	http://localhost/ = app endpoint

This simulates 10 users accessing the app at the same time.

## Step 5: Observe CloudWatch Metrics During Testing

While the test was running:

	• CPU utilisation increased
	• Network traffic increased
	• Response times could be observed in Apache Bench output

This confirmed that the app and VM were responding correctly to load.


## Monitoring and Load Testing

The following diagram shows how monitoring was added to the App VM using AWS CloudWatch.
CPU utilisation is tracked to understand how the Node.js application behaves under load
and to support alerting and auto scaling decisions.



## CloudWatch Alarm: High CPU Utilisation

A CloudWatch alarm was created to monitor CPU usage on the App VM.
This alarm tracks the EC2 `CPUUtilization` metric and triggers when
average CPU usage exceeds 70% for one minute.

The purpose of this alarm is to detect performance issues early,
before the application becomes unresponsive. When the threshold
is breached, the alarm sends a notification using Amazon SNS.

This demonstrates how monitoring and alerting are used together
to improve reliability and support future auto scaling decisions.


### Creating the CloudWatch Alarm

A CPU utilisation alarm was created for the App VM using AWS CloudWatch.

Steps taken:
	•	Opened AWS CloudWatch
	•	Navigated to Alarms → Create alarm
	•	Selected the App VM as the monitored resource
	•	Chose the CPUUtilization metric
	•	Set the threshold to trigger when CPU usage goes above 60%
	•	Configured the alarm to evaluate every 1 minute
	•	Linked the alarm to an SNS topic
	•	Added my email address to receive notifications
	•	Confirmed the subscription email sent by AWS

This ensures I receive alerts if the VM becomes overloaded.

⸻

#### Triggering the Alarm (Testing)

To verify the alarm worked correctly, I deliberately increased CPU usage on the App VM.

Steps:

1.	SSH into the App VM using the public IP
2.	Installed a stress testing tool:
```
sudo apt update
sudo apt install -y stress
```
3.	Generated CPU load:
```
stress --cpu 2 --timeout 300
```
This command forces the VM to use high CPU for 5 minutes.

⸻

#### Alarm Behaviour
•	While the stress command was running, CPU utilisation increased above 60%

•	The CloudWatch alarm changed state from OK to In Alarm

•	An email notification was sent to confirm the alert triggered

•	Once the stress test finished, CPU usage dropped

•	The alarm automatically returned to OK

This confirmed the alarm was working as expected.

⸻

#### Why This Is Important

Monitoring and alerting are essential in real world deployments because:
•	Issues can be detected before users notice problems

•	Engineers can respond quickly to performance spikes

•	It prevents downtime and improves reliability

•	It provides visibility into system health

This monitoring setup ensures the Node.js application VM can be safely observed under load.

#### Screen Shots

