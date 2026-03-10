# ── versions.tf ────────────────────────────────────

terraform {
  required_version = ">= 0.12"
}


# ── 00-params.tf ────────────────────────────────────
# parms file for aws ec2 cloud

#### VPC Network
variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

#### HTTP PARAMS
variable "network_http" {
  default = {
    subnet_name = "subnet_http"
    cidr        = "192.168.1.0/24"
  }
}

# Set number of instance
variable "autoscaling_http" {
  default = {
    desired_capacity = "2"
    max_size         = "5"
    min_size         = "2"
  }
}

#### DB PARAMS
variable "network_db" {
  default = {
    subnet_name = "subnet_db"
    cidr        = "192.168.2.0/24"
  }
}

# Set number of instance
variable "autoscaling_db" {
  default = {
    desired_capacity = "2"
    max_size         = "5"
    min_size         = "1"
  }
}



# ── 010-ssh-key.tf ────────────────────────────────────
# Define ssh to config in instance

# Create default ssh publique key
resource "aws_key_pair" "user_key" {
  key_name   = "user-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 email@example.com"
}



# ── 015-ami.tf ────────────────────────────────────
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


# ── 020-network.tf ────────────────────────────────────
# Network configuration

# VPC creation
resource "aws_vpc" "terraform" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "vpc_http"
  }
}

# http subnet configuration
resource "aws_subnet" "http" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.network_http["cidr"]
  tags = {
    Name = "subnet_http"
  }
  depends_on = [aws_internet_gateway.gw]
}

# db subnet configuration
resource "aws_subnet" "db" {
  vpc_id     = aws_vpc.terraform.id
  cidr_block = var.network_db["cidr"]
  tags = {
    Name = "subnet_db"
  }
  depends_on = [aws_internet_gateway.gw]
}

# External gateway configuration
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.terraform.id
  tags = {
    Name = "internet_gateway"
  }
}



# ── 030-security-group.tf ────────────────────────────────────
# Security group configuration

# Default administration port
resource "aws_security_group" "administration" {
  name        = "administration"
  description = "Allow default administration service"
  vpc_id      = aws_vpc.terraform.id
  tags = {
    Name = "administration"
  }

  # Open ssh port
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow icmp
  ingress {
    from_port   = 8
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open access to public network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Open web port
resource "aws_security_group" "web" {
  name        = "web"
  description = "Allow web incgress trafic"
  vpc_id      = aws_vpc.terraform.id
  tags = {
    Name = "web"
  }

  # http port
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # https port
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open access to public network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Open database port
resource "aws_security_group" "db" {
  name        = "db"
  description = "Allow db incgress trafic"
  vpc_id      = aws_vpc.terraform.id
  tags = {
    Name = "db"
  }

  # db port
  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Open access to public network
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



# ── 060-instance-http.tf ────────────────────────────────────
#### INSTANCE HTTP ####

# Create load balancer
resource "aws_elb" "http" {
  name    = "http-lb"
  subnets = [aws_subnet.http.id]

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "HTTP:80/"
    interval            = 30
  }
  tags = {
    Name = "http-lb"
  }
}

# Create autoscaling group
resource "aws_autoscaling_group" "http" {
  name                      = "http-autoscaling-group"
  max_size                  = var.autoscaling_http["max_size"]
  min_size                  = var.autoscaling_http["min_size"]
  desired_capacity          = var.autoscaling_http["desired_capacity"]
  health_check_type         = "ELB"
  default_cooldown          = "30"
  health_check_grace_period = "120"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.http.name
  load_balancers            = [aws_elb.http.name]
  termination_policies      = ["OldestLaunchConfiguration"]
  vpc_zone_identifier       = [aws_subnet.http.id]
}

# Configure instance launching configuration
resource "aws_launch_configuration" "http" {
  name_prefix   = "http"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.user_key.key_name
  security_groups = [
    aws_security_group.administration.id,
    aws_security_group.web.id,
  ]
  user_data = file("scripts/first-boot-http.sh")
}



# ── 061-instance-db.tf ────────────────────────────────────
#### INSTANCE DB ####

# Create load balancer
resource "aws_elb" "db" {
  name     = "db-lb"
  subnets  = [aws_subnet.db.id]
  internal = "true"

  listener {
    instance_port     = 3306
    instance_protocol = "tcp"
    lb_port           = 3306
    lb_protocol       = "tcp"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    target              = "TCP:3306"
    interval            = 30
  }
  tags = {
    Name = "db-lb"
  }
}

# Create autoscaling group
resource "aws_autoscaling_group" "db" {
  name                      = "db-autoscaling-group"
  max_size                  = var.autoscaling_db["max_size"]
  min_size                  = var.autoscaling_db["min_size"]
  desired_capacity          = var.autoscaling_db["desired_capacity"]
  health_check_type         = "ELB"
  default_cooldown          = "30"
  health_check_grace_period = "120"
  force_delete              = true
  launch_configuration      = aws_launch_configuration.db.name
  load_balancers            = [aws_elb.db.name]
  termination_policies      = ["OldestLaunchConfiguration"]
  vpc_zone_identifier       = [aws_subnet.db.id]
}

# Configure instance launching configuration
resource "aws_launch_configuration" "db" {
  name_prefix   = "db"
  image_id      = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = aws_key_pair.user_key.key_name
  security_groups = [
    aws_security_group.administration.id,
    aws_security_group.web.id,
  ]
  user_data = file("scripts/first-boot-db.sh")
}



# ── 071-routing-table.tf ────────────────────────────────────
# Create ande associate route

# Routing table configuration
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.terraform.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

# Associate http route
resource "aws_route_table_association" "http" {
  subnet_id      = aws_subnet.http.id
  route_table_id = aws_route_table.public.id
}

# Associate db route
resource "aws_route_table_association" "db" {
  subnet_id      = aws_subnet.db.id
  route_table_id = aws_route_table.public.id
}



# ── 100-outputs.tf ────────────────────────────────────
# Display output information

# Display http loadbalancer dns name
output "lb_hostname_http" {
  value = aws_elb.http.dns_name
}

# Display db loadbalancer dns name
output "lb_hostname_db" {
  value = aws_elb.db.dns_name
}

