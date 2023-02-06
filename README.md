## AWS Deployment Automation Using Terraform and Ansible
![Archeiture Diagram](images/terra.png)

## Scenario:
You're tasked to deploy webpages in multiple EC2 instances and attach to a Load Balancer all set up using Terraform. Ansible would handle the instances configurations by working with the output from terraform. Terraform should also link the load balncer's domain to a sub-domain called _terraform-test.yourdomain.com_ of your custom domain name, request and validate an ssl certifcate. 
Visiting `terraform-test.yourdomain.me` should display all instances webpages.

## Essentials:
* An AWS Account.
* A linux/mac system or instance or virtual machine or droplets
* Be logged in an IAM user with Admin priviledges 
* A custom domain name (sub-domain would be mapped)
* An S3 bucket to store the terraform state files remotely

## Procedures:
I am currently writing a well detailed article with all research I did on this, note this [link](https://dev.to/wandexdev) when it drops. Here is a summary of the steps.
<br>
- Install latest Terraform on the command line
- Install latest Ansible on th ecommand line
- Create a terraform folder (working directory), `cd` into it and `code` to open vs code
- Install the terraform extension by _Anton Kulikov_
- Install AWS CLI and Configure with `aws configure`
	- fill up outputs with credentials previously created from IAM user
	- add preferred region 
	- Test configuration details with `aws configure list`
	- No need to create environment variables as `env | grep AWS` will not recognize the enviroment variables set in another terminal tab hence `aws configure` is appropriate for global setup.
- Create a **variables.tf** file to declare variables used in this project and a **terraform.tfvars** file to input the variable values.
- Create a **s3_backend.tf** file to store remote state files as this ensures multiples users or CI server gets the latest state data before running terraform. Its also more secure. Fill up  




## Final Output: visit secured [terraform-test.wandexdev.me](terraform-test.wandexdev.me)
Instance 1
![i1](images/i1.png)
Instance 2
![i2](images/i2.png)
instance 3
![i3](images/i3.png)

## Screenshots:
* Remote Backend:
![s3](images/backend.png)
* Network:
	* VPC
![vpc](images/vpc.png)
	* SUBNETS
![subnets](images/subnets.png)
	* Custom-DEFAULT ROUTE TABLES
![rt](images/rt.png)
	* INTERNET GATEWAY (IGW)
![igw](images/igw.png)
	* SECURITY GROUPS (Instances and ALB)
![sg](images/sg.png)
	 
* Servers: 
	* Instances
![instances](images/instances.png)
	* KEY PAIR
![kp](images/keypair.png)
	* APPLICATION LOAD BALANCERS (ALB)
![ALB](images/alb.png)

