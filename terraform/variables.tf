#----------------------------BACKEND-------------------------
variable "S3_bucket_name" {
    description = "remote backend storage for safe guarding the terraform state and backup files"
}


variable "bucket_key" {
    description = "It's the file path inside the bucket"
}

#--------------------------------NETWORK-------------------------------#

variable "vpc_cidr_block" {
    description = "ip range for vpc"
}

variable "environment_prefix" {
  description = "environment name for the archeiture"
}

variable "subnet_cidr_block" {
  description = "ip range, name and availability zone for subnets"
  type = map(object({
    cidr = string
    az = string
  }))
}

variable "inbound_ports" {
  description = "Inbound traffic ports for Security groups"
  type = list(number)
  default = [80,443]
}

variable "alltraffic_cidr_block" {
    description = "access from the entire internet"
}

#--------------------------------SERVERS-------------------------------#
variable "key_pair" {
    description = "name of key pair"
}

variable "local_public_key_location" {
    description = "my personal public key"
}

variable "local_private_key_location" {
    description = "my personal private key"
}

variable "instance_type" {
    description = "specific type of instance"
}

variable "existing_domain" {
    description = "domain for my hosted zone"
}

variable "subdomain_name" {
    description = "subdomain name for my alb dns"
}

variable "CNAME" {
    description = "CNAME to validate that we own the domain name pending a cert"
}

variable "CNAME_value_from_ACM" {
    description = "value provided by ACM to validate thr domain name"
}

variable "certificate_arn" {
    description = "cert arn value needed for setting up ALB listener"
}