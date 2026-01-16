## Environment Variables and Processes

- [Environment Variables and Processes](#environment-variables-and-processes)
- [What Are Environment Variables?](#what-are-environment-variables)
- [Viewing Environment Variables](#viewing-environment-variables)
  - [View all environment variables:](#view-all-environment-variables)
- [Setting Environment Variables](#setting-environment-variables)
- [How Environment Variables and Processes Are Connected](#how-environment-variables-and-processes-are-connected)
- [Viewing Processes](#viewing-processes)
- [The kill Command](#the-kill-command)
  - [Common Kill Signals (Essential)](#common-kill-signals-essential)
  - [Terminate Signal (default)](#terminate-signal-default)
  - [Force Kill (SIGKILL – signal 9)](#force-kill-sigkill--signal-9)


## What Are Environment Variables?

Environment variables are key-value pairs that store configuration data for processes.
```
USER=ubuntu
HOME=/home/ubuntu
PATH=/usr/bin:/bin
```
They are used to:

	•	Configure applications
	•	Store system settings
	•	Pass information to child processes

## Viewing Environment Variables

### View all environment variables:
```
printenv
```
View a specific variable:
```
printenv USER
```
OR:
```
echo $USER
```
## Setting Environment Variables

Temporary (current session only):
```
export MYVAR=hello
```
Removing Environment Variables
```
unset MYVAR
```
## How Environment Variables and Processes Are Connected
	•	Environment variables are passed from parent → child
	•	A process cannot change the parent’s environment
	•	Each process gets its own copy of the environment

Example:

	•	Shell sets MYNAME=alex
	•	Python process inherits it
	•	Python can read it, but cannot modify the shell’s version

## Viewing Processes

What is a Process?

A process is a running instance of a program.

Show running processes:
```
ps
```
show all processes 
```
ps aux 
```
showing current shell process: 
```
ps -p $
```
## The kill Command

The kill command sends signals to processes.

It does not always kill a process — it sends a signal asking it to act.
```
kill -SIGNAL PID
```
### Common Kill Signals (Essential)

Hangup Signal (SIGHUP – signal 1)
```
kill -1 PID
```
Purpose:
	•	Tells a process its controlling terminal closed
	•	Often used to reload configuration files

Example use:
	•	Reloading services without stopping them


### Terminate Signal (default)
```
kill PID
```
Purpose:
	•	Politely asks the process to stop
	•	Allows cleanup before exiting

This is the recommended first option.

### Force Kill (SIGKILL – signal 9)
```
kill -9 PID
```
Purpose:
	•	Immediately stops the process
	•	No cleanup
	•	Cannot be ignored

Used only when:
	•	Process is frozen
	•	SIGTERM does not work


