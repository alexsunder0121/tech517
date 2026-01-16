# Scripting Documentation Tasks

- [Scripting Documentation Tasks](#scripting-documentation-tasks)
  - [Linux File Ownership and Permissions (Beginner Notes)](#linux-file-ownership-and-permissions-beginner-notes)
    - [Why is Managing File Ownership Important?](#why-is-managing-file-ownership-important)
    - [What Is the Command to View File Ownership?](#what-is-the-command-to-view-file-ownership)
    - [What permissions are set when a user creates a file or directory?](#what-permissions-are-set-when-a-user-creates-a-file-or-directory)
    - [Who does a file or directory belong to?](#who-does-a-file-or-directory-belong-to)
    - [Why does the owner not receive execute (X) permissions by default?](#why-does-the-owner-not-receive-execute-x-permissions-by-default)
    - [What command is used to change the owner of a file or directory?](#what-command-is-used-to-change-the-owner-of-a-file-or-directory)


---

## Linux File Ownership and Permissions (Beginner Notes)

This part of the document covers file ownership and permissions in Linux, based on hands-on testing on a cloud VM.

### Why is Managing File Ownership Important?

Managing file ownership is important because it controls **who can access, modify, or execute files and directories**.

In Linux systems (especially cloud servers):
- Multiple users may access the same machine
- Services run under specific users
- Sensitive files must be protected

Correct ownership helps:
- Prevent unauthorised access
- Protect system and application files
- Reduce security risks
- Ensure applications run correctly

In cloud environments, good ownership and permissions are **critical for security and reliability**.

---

### What Is the Command to View File Ownership?

The main command used is:

``` bash
ls -l
```

### What permissions are set when a user creates a file or directory?

When a user creates a file or directory, Linux assigns default permissions.

Typical default permissions are:
	•	Files: rw-r--r-- (644)
	•	Directories: rwxr-xr-x (755)

This means the owner can read and write files and has full access to directories, while other users have limited access.


### Who does a file or directory belong to?

By default, a file or directory belongs to the user who created it and that user’s primary group.

Example:

~~~ bash
touch file.txt

ls -l file.txt

Output:

-rw-r--r-- 1 ubuntu ubuntu file.txt
~~~

### Why does the owner not receive execute (X) permissions by default?

Files are not executable by default for security reasons. Most files are data files, such as text or configuration files, and should not be run as programs.

Linux requires execute permissions to be explicitly added to prevent accidental or malicious execution of files.

Example:

chmod +x script.sh

### What command is used to change the owner of a file or directory?

The command used to change ownership is:

```bash
chown
```

Change the owner of a file:
```bash
sudo chown alex file.txt
```

Change the owner and group:
```bash
sudo chown alex:developers file.txt
```
Change ownership recursively for a directory:
```bash
sudo chown -R alex folder/
```