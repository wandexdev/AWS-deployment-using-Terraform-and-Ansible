#------------------------------AMI DATA SOURCE-----------------------------#

data "aws_ami" "latest_ubuntu_image" {
  most_recent      = true
  owners           = ["amazon"]

  filter {
    name           = "name"
    values         = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]  #The reg expression at the denotes anyvalue
  }

  filter {
    name           = "virtualization-type"
    values         = ["hvm"]
  }
}

#-------------------------------KEY PAIR----------------------------#

resource "aws_key_pair" "wandeminiproject" {
  key_name   = var.key_pair
  public_key = "${file(var.local_public_key_location)}"
}

#-------------------------------INSTANCES----------------------------#

resource "aws_instance" "wandeminiproject" {
  for_each                     = aws_subnet.wandeminiproject
  ami                          = data.aws_ami.latest_ubuntu_image.id
  instance_type                = var.instance_type
  subnet_id                    = each.value.id
  vpc_security_group_ids       = [aws_security_group.wandeminiproject.id]
  associate_public_ip_address  = true
  key_name                     = aws_key_pair.wandeminiproject.key_name

  tags = {
    Name = "${var.environment_prefix}-server-"
  }

#--------------------------------REMOTE INSTANCES CONNECTION-------------------------------#

  connection {
    type = "ssh"
    host = self.public_ip
    user = "ubuntu"
    private_key = "${file(var.local_private_key_location)}"
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'provisioner worked!'",  # Somewhat Pinging the instances
    ]
  }

  provisioner "local-exec" {
    command    = "echo '${self.public_ip}' >> ./host-inventory"  #creating the host-inventory my local system
  }

}

#----------------------------ANSIBLE CONNECTION IN TERRAFORM---------------------------#

resource "null_resource" "ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i host-inventory --private-key=${file(var.local_private_key_location)} playbook.yml"
  }

  depends_on = [aws_instance.wandeminiproject]
} 