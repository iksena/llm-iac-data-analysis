# ── main.tf ────────────────────────────────────
terraform {
    backend "s3" {
    bucket           = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt          = true
    key              = "aws/tfstates/ec2-create/terraform.tfstate"
    region           = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}


# ── variables.tf ────────────────────────────────────
variable "monitoring_value" {
    description = "Enable detailed monitoring"
    type        = bool
    default     = false
}

variable "instance_type" {
    description = "Define instance type"
    type        = string
    default     = "t2.micro"
}

variable "common_tags" {
    description = "Tags to apply to all resources"
    type        = map(string)
    default     = {
        Owner       = "Valerii Vasianovych"
        Project     = "AWS Instance Creation"
        Environment = "Development"
    }
}

variable "allow_security_groups_ports" {
    description = "The ports to open on the security group"
    type        = list(number)
    default     = [22, 80, 443]
}

# ── outputs.tf ────────────────────────────────────
output "aws_caller_identity" {
    value = data.aws_caller_identity.current
}

output "aws_region" {
    value = data.aws_region.current.name
}

output "aws_region_description" {
    value = data.aws_region.current.description
}

output "aws_availability_zones" {
    value = data.aws_availability_zones.available
}


# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_region" "available" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}




# ── ec2-resource.tf ────────────────────────────────────
resource "aws_instance" "ubuntu_instance" {
    ami                    = data.aws_ami.latest_ubuntu.id
    instance_type          = var.instance_type
    key_name               = "ServersKey"
    vpc_security_group_ids = [aws_security_group.instance_security_group.id]
    user_data              = file("install-nginx.sh")
    monitoring             = var.monitoring_value

    tags = merge(var.common_tags, {
      Name = "Latest Ubuntu Instance"
      Year = 2024
    })
}

resource "aws_security_group" "instance_security_group" {
  name        = "Instance Security Group"
  description = "Allow HTTP and HTTPS inbound traffic"

  dynamic "ingress" {
    for_each = var.allow_security_groups_ports
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
        Name = "Instance Security Group"
        Year = 2024
    })
}
