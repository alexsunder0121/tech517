# Terraform Variables Documentation

This document explains the Terraform variables used in the 2 tier AWS deployment.
Variables are used to make the infrastructure reusable, readable, and easy to change without editing core Terraform code.

---

## Why We Use Variables in Terraform

Using variables allows us to:
- Avoid hardcoding values in Terraform files
- Reuse the same configuration across environments (dev, test, prod)
- Make updates safer and faster
- Keep sensitive or environment specific values in one place

---

## AWS Configuration Variables

### default_aws_region
```hcl
variable "defualt_aws_region" {
  description = "The default AWS region where resources are created"
  default     = "eu-west-1"
}