# Linux Command Notes (Clean Revision)

These are the key commands from your history, grouped by purpose with short explanations.

---

## 1) Basics and System Info

- `uname`  
  Shows the system name.

- `uname -a`  
  Shows full system information (kernel, architecture, etc.).

- `whoami`  
  Shows the current user.

- `history`  
  Shows your command history.

- `exit`  
  Exits the current session or shell.

---

## 2) Navigating the File System

- `pwd`  
  Prints your current directory path.

- `ls`  
  Lists files and folders.

- `ls -a`  
  Lists all files including hidden files.

- `ls -l`  
  Lists files with permissions, owner, size, and date.

- `ls -al`  
  Combines `-a` and `-l`.

- `cd <folder>`  
  Moves into a folder.

- `cd ..`  
  Moves up one directory.

- `cd`  
  Takes you back to your home directory.

- `cd /`  
  Takes you to the root directory.

- `cd .`  
  Stays in the current directory (rarely needed, but good to understand).

---

## 3) Viewing and Editing Files

- `touch file.txt`  
  Creates an empty file (or updates its timestamp).

- `nano file.txt`  
  Opens a file in the Nano editor.

- `cat file.txt`  
  Prints the entire file content.

- `head -2 file.txt`  
  Prints the first 2 lines.

- `tail -2 file.txt`  
  Prints the last 2 lines.

- `nl file.txt`  
  Prints file content with line numbers.

---

## 4) Searching Inside Files

- `grep "word" file.txt`  
  Finds matching lines in a file.

Example:
- `grep "chicken" chicken-joke.txt`

---

## 5) Downloading Files from the Internet

- `curl <url> --output filename`  
  Downloads a file and saves it with a chosen name.

Example:
- `curl https://example.com/pic.jpg --output cat.jpg`

- `wget <url>`  
  Downloads a file (saves using original filename by default).

---

## 6) File and Folder Management

- `file cat.jpg`  
  Tells you what type of file it is.

- `mv old new`  
  Renames a file or moves it.

Examples:
- Rename: `mv chicken-joke.txt bad-joke.txt`
- Move: `mv bad-joke.txt funny-jokes/`

- `cp source destination`  
  Copies a file.

Example:
- `cp bad-joke.txt ~` (copies to home folder)

- `rm file.txt`  
  Deletes a file.

- `rm -r foldername/`  
  Deletes a folder and everything inside it.

- `mkdir foldername`  
  Creates a folder.

- `mkdir "my pictures"`  
  Creates a folder with spaces (use quotes).

---

## 7) Seeing Folder Structure

- `tree`  
  Shows folders and files in a tree format.

If it is not installed:
- `sudo apt update`
- `sudo apt install tree -y`

---

## 8) Permissions and Running Scripts

- `chmod +x script.sh`  
  Makes a script executable.

- `./script.sh`  
  Runs a script from the current folder.

---

## 9) Installing and Updating Packages (Ubuntu)

- `sudo apt update`  
  Refreshes package list.

- `sudo apt install <package> -y`  
  Installs a package.

Example:
- `sudo apt install nginx -y`

- `sudo apt upgrade -y`  
  Upgrades installed packages.

---

## 10) Services (nginx with systemctl)

- `systemctl status nginx`  
  Checks nginx service status.

- `sudo systemctl enable nginx`  
  Starts nginx on boot.

- `sudo systemctl is-enabled nginx`  
  Checks if nginx starts on boot.

- `sudo systemctl stop nginx`  
  Stops nginx service.

---

## 11) Switching User

- `sudo su`  
  Switches to root user (admin shell).

---

# Quick Common Command Flow (Simple Task)

## Create and edit a file
- `touch notes.txt`
- `nano notes.txt`
- `cat notes.txt`

## Create folders and organise files
- `mkdir project`
- `mv notes.txt project/`
- `tree`

## Install a tool and verify
- `sudo apt update`
- `sudo apt install tree -y`
- `tree`

## Install nginx and check it
- `sudo apt install nginx -y`
- `systemctl status nginx`