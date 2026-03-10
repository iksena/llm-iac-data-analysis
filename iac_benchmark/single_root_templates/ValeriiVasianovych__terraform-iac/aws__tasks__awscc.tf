# ── main.tf ────────────────────────────────────
provider "aws" {
  region = "us-east-1"
}

provider "awscc" {
  region = "us-east-1"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "tags" {
  default = {
    Owner   = "Valerii Vasianovych with ID"
    Project = "Cybersecurity Project in us-east-1 region. Project: AWS Cloud and Terraform IaC"
  }
}

locals {
  refformat_tags = [for key, value in var.tags : {
    key   = key
    value = value
  }]
}

resource "aws_instance" "ubuntu_ec2" {
  ami           = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  key_name      = "aws_ssh_key"
  # add security group
  vpc_security_group_ids = [awscc_ec2_security_group.sg.id]
  tags          = merge(var.tags, { Name = "Instance A" })
}

resource "awscc_ec2_instance" "ubuntu_ec2" {
  image_id      = data.aws_ami.latest_ubuntu.id
  instance_type = "t2.micro"
  key_name      = "aws_ssh_key"
  security_group_ids = [awscc_ec2_security_group.sg.id]
  tags          = concat(local.refformat_tags, [{
    key   = "Name"
    value = "Instance B"
  }])
}

resource "awscc_ec2_security_group" "sg" {
  group_description = "Security group allowing HTTP, HTTPS, SSH and ICMP access"
  vpc_id            = data.aws_vpc.default.id
  
  security_group_ingress = [
    {
      ip_protocol = "tcp"
      from_port   = 80
      to_port     = 80
      cidr_ip     = "0.0.0.0/0"
      description = "Allow HTTP access"
    },
    {
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_ip     = "0.0.0.0/0"
      description = "Allow HTTPS access"
    },
    {
      ip_protocol = "tcp"
      from_port   = 22
      to_port     = 22
      cidr_ip     = "0.0.0.0/0"
      description = "Allow SSH access"
    },
    {
      ip_protocol = "icmp"
      from_port   = -1
      to_port     = -1
      cidr_ip     = "0.0.0.0/0"
      description = "Allow ICMP (ping)"
    }
  ]

  security_group_egress = [
    {
      ip_protocol = "-1"
      from_port   = -1
      to_port     = -1
      cidr_ip     = "0.0.0.0/0"
      description = "Allow all outbound traffic"
    }
  ]

  tags = concat(local.refformat_tags, [{
    key   = "Name"
    value = "allow-web-ssh"
  }])
}

# ── datasource.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_vpc" "default" {
  default = true
}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}


