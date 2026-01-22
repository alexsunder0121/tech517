🔴 Stage 1: No Monitoring (Worst)

What to draw
	•	App VM box
	•	Arrow down saying “CPU load too high”
	•	App crash icon

Annotations
	•	No CloudWatch
	•	No alerts
	•	App crashes
	•	Users report problems

No monitoring
CPU spike → app crashes
Issue only noticed by users


🟠 Stage 2: Basic Monitoring (Dashboard only)

What to draw
	•	App VM
	•	CloudWatch dashboard icon
	•	CPU graph

Annotations
	•	CPU metrics collected
	•	Manual checking


CloudWatch metrics enabled
CPU visible on dashboard
Engineer must manually check
Easy to miss issues


🟡 Stage 3: Monitoring + Alerts

What to draw
	•	App VM
	•	CloudWatch alarm
	•	Bell / phone notification

Annotations
	•	CPU > 80%
	•	Alarm triggers notification


CloudWatch alarm configured
CPU > 80% triggers alert
Engineer notified quickly
Less downtime



🟢 Stage 4: Monitoring + Autoscaling (Best)

What to draw
	•	App VM
	•	CloudWatch alarm
	•	Arrow to multiple App VMs

Annotations
	•	Auto Scaling Group
	•	New VM created automatically



CPU alarm triggers autoscaling
New App VM created automatically
System handles high traffic
Self-healing architecture


![Monitoring Diagram](Monitoring/monitoring.png)


