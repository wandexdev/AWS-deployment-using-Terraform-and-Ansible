## AWS Deployment Automation Using Terraform and Ansible
![Archeiture Diagram](terra.png)

## Scenario:
You're tasked to deploy webpages in multiple EC2 instances and attach to a Load Balancer all set up using Terraform. Ansible would handle the instances configurations by working with the output from terraform. Visiting `terraform-test.yourdomain.me` should display all instances webpages.

## Essentials:
* An AWS Account.
* A linux/mac system or instance or virtual machine or droplets
* Be logged in an IAM user with Admin priviledges 
* A custom domain name (sub-domain would be mapped)

## Procedures:
`I am currently writing a well detailed article with all research I did on this, note this [link](https://dev.to/wandexdev)when it drops`

## Screenshots:
* Network:
	* VPC
![vpc](Images/vpc.png)
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

## Final Output:
Instance 1
