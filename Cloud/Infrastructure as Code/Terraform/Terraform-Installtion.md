# Installing Terraform on macOS (Local Machine Setup)

## Overview

In this task, I installed Terraform on my Mac so I could begin using Infrastructure as Code (IaC) to deploy and manage cloud resources. Terraform was installed using Homebrew, which is the recommended package manager for macOS.

This setup allows Terraform to be run from anywhere on the system and makes future updates easy.

---

## Step 1: Check if Homebrew Is Installed

First, I checked whether Homebrew was already installed:

```bash
brew --version
```

## Step 2: Install Homebrew

Since Homebrew was not installed, I installed it using the official command:

```/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"```

After installation, I followed the on screen instructions to add Homebrew to my PATH.

For Apple Silicon Macs, this command was required:

```
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

To confirm Homebrew was installed correctly:
```brew --version```

## Step 3: Install Terraform Using Homebrew

With Homebrew installed, I installed Terraform:

```brew install terraform```

This downloads Terraform and places it in a standard system location used for command line tools.

## Step 4: Verify Terraform Installation

To confirm Terraform was installed correctly, I ran:

```terraform version```


