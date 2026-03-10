# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/tasks/aws-ec2/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

resource "aws_instance" "ubuntu_ec2" {
    count = var.count_instance
    ami = data.aws_ami.latest_ubuntu.id
    availability_zone = "${var.region}a"
    instance_type = var.instance_type
    key_name = var.key_name
    user_data = file("${path.module}/install-nginx.sh")
    vpc_security_group_ids = [aws_security_group.sg.id]
    tags = merge(var.common_tags, {
        Name = "ec2-instance-${count.index + 1}"
    })
}

resource "aws_security_group" "sg" {
  name   = "sg"
  description = "An example security group for Terraform"

  dynamic "ingress" {
    for_each = [22, 80, 443]
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

    tags = merge(var.common_tags, {
        Name = "sg"
    })
}

# ── variables.tf ────────────────────────────────────
variable "region" {
    type = string
    description = "The region in which to launch the EC2 instance"
    default = "us-east-1"
}

variable "instance_type" {
    type = string
    description = "The type of instance to launch"
    default = "t2.micro" 
}

variable "key_name" {
    type = string
    description = "The name of the key pair to use for the instance"
    default = "aws_ssh_key"
  
}

variable "common_tags" {
    type = map(string)
    description = "Common tags to apply to all resources"
    default = {
        Owner = "Valerii Vasianovych"
        Project = "Test Project"
    }
}

variable "count_instance" {
    type = number
    description = "The number of instances to launch"
    default = 2
}

# ── outputs.tf ────────────────────────────────────
output "get_public_ip" {
  value = aws_instance.ubuntu_ec2[*].public_ip
}

output "lookup_example" {
  value = lookup({a="ay", b="bee"}, "c", "what?")
}

# ── datasource.tf ────────────────────────────────────
data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {}
data "aws_region" "current" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}


