# Terraform 

## Intro to Terraform 

### What is Terraform? What is it used for?

* IaC type: orchestration tool 
* Infrastructure provisioning tool 
* Manging cloud resources
* Orginally inspired by AWS CloudFormation
* Differernt to configuration management tools like Ansible which deploy software onto exisiting servers
* Sees infrastructure as immutable (disposable)
* Uses code written in HCL (Hashicorp Configuration Language) - aims to be a good balance between human and machine readable 
  * HCL can be converted 1:1 to JSON and vice versa

### Why use Terraform? The benefits?
* Declarative - say what you want, not how to do it  
* Easy to use
* Sort of open-source
  * In 2023, started using a Business Source License (BSL) 
    * This means... 
      * Terraform can't be used to create a competing commerical product
      * Some organisations have started using OpenTofu instead
        * OpenTofu aims to be a drop-in replacement 
* Cloud-agnostic - deploy to any cloud privider
  * Use different providers (like a plugin) to interface with differernt cloud providers
  * Each cloud vendor maintains its own provider 
  * Expressive (refering to the language) and extendible (refering to being able to use different providers to manage different resources) 


### Alternatives to Terraform

* Pulumi (Not declarative)
* finish off...


### In IaC, What is orchestration?

* Process of automating and managaing the entire lifecycle of infrastructure resources

### How does Terraform act as 'orchestrator'?

* Co-ordinating the piece of infrastructure to work together 
  * Includes
    * Setting things up/destroying in the right order
    * Make sure things are connected together properly 

To do this, it relies on understanding the dependecies between resources

### Best practice supplying AWS credentials to Terraform

What is the order in which Terraform looks uo AWS credentials (which ways take precendece/priority)?
1. Env variables: AWS_ACESS_KEY_ID and  AWS_SECRET_KEY (Mediocre unless you tempoaryily set them such as through a key vault to retreive them when needed)
2. Terraform variables (WORST in terms of security)

  Example:
  ```
  provider "aws" {
  access_key = "your_access_key"
  secret_key = "your_secret_key"  
  }
  ```

  💥DANGER! NEVER DO THIS! Always avoid hard-coding credentials

3. AWS CLI shared credentials file (saved when you do `aws configure` command) (Mediocre in terms of security)
4. If your using Terraform through and EC2 instance, set IAM role permissions (BEST)


### Why use Terraform for different enviornments (e.g. production, testing, etc)

* Production environemnts 
  * Easily create a larger-scale or more scalable version of infrastructure 

* Dev and Testing enviroments 
  * Easily spin up infrastructure for testing/dv that mirrors production 
  * Easily tear it down when not needed
  * 


