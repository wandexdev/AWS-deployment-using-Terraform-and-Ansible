#--------------------------------VPC-------------------------------#

resource "aws_vpc" "wandeminiproject" {
    cidr_block             = var.vpc_cidr_block
    enable_dns_hostnames   = true
    tags = {
        Name = "${var.environment_prefix}-vpc"
  }
}

#--------------------------------SUBNET-------------------------------#

resource "aws_subnet" "wandeminiproject" {
    for_each          = var.subnet_cidr_block
    vpc_id            = aws_vpc.wandeminiproject.id
    cidr_block        = each.value["cidr"]
    availability_zone = each.value["az"]
    tags = {
        Name = each.key
  }
}

#--------------------------------INTERNET GATEWAY-------------------------------#

resource "aws_internet_gateway" "wandeminiproject" {
    vpc_id = aws_vpc.wandeminiproject.id
    tags = {
        Name = "${var.environment_prefix}-IGW"
  }
}

#--------------------------------DEFAULT ROUTE TABLE-------------------------------#
# personalized the default RT created with my VPC; hence no subnet association needed

resource "aws_default_route_table" "wandeminiproject" { 
  default_route_table_id = aws_vpc.wandeminiproject.default_route_table_id

  route {
    cidr_block           = var.alltraffic_cidr_block
    gateway_id           = aws_internet_gateway.wandeminiproject.id
  }
  tags = {
    Name = "${var.environment_prefix}-RT"
  }
}

#--------------------------------INSTANCES SECURITY GROUP-------------------------------#

resource "aws_security_group" "wandeminiproject" {
    name                 = "wandeminiproject-SG"
    description          = "Allow HTTP and HTTPS inbound traffic"
    vpc_id               = aws_vpc.wandeminiproject.id

    dynamic "ingress" {
    for_each            = var.inbound_ports

    content {
      from_port         = ingress.value
      to_port           = ingress.value
      protocol          = "tcp"
      security_groups   = [aws_security_group.wandeminiproject-ALB-SG.id]
    }
  }

  ingress {
    description         = "Allow SSH"
    from_port           = 22
    to_port             = 22
    protocol            = "tcp"
    cidr_blocks         = [var.alltraffic_cidr_block]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.alltraffic_cidr_block]
  }

  tags = {
    Name = "${var.environment_prefix}-SG"
  }
}

#--------------------------------APPLICATION LOAD BALANCER-SECURITY GROUP-------------------------------#

resource "aws_security_group" "wandeminiproject-ALB-SG" {
  name                  = "wandeminiproject-ALB-SG"
  description           = "Allow HTTPS and HTTP inbound traffic for application load balancer"
  vpc_id                = aws_vpc.wandeminiproject.id

  dynamic "ingress" {
    for_each            = var.inbound_ports

    content {
      from_port         = ingress.value
      to_port           = ingress.value
      protocol          = "tcp"
      cidr_blocks       = [var.alltraffic_cidr_block]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = [var.alltraffic_cidr_block]
  }

  tags = {
    Name = "${var.environment_prefix}-ALB-SG"
  }
}

