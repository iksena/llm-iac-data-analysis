# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/lifecycles/terraform.tfstate"
    region  = "us-east-1"
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
  region = var.aws_region
}

resource "aws_instance" "lifecycle_instance" {
  ami                    = "ami-07d9b9ddc6cd8dd30"
  instance_type          = var.instance_type
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.lifecycle_security_group.id]

  # Lifecycle rules for instance
  lifecycle {
    # Uncomment below lines to prevent instance from being destroyed or to ignore changes to specified attributes
    # prevent_destroy = true
    # ignore_changes  = [ami, instance_type]
  }

  tags = merge(var.common_tags, {
  })
}


# ── variables.tf ────────────────────────────────────
variable "aws_region" {
  description = "Region to deploy the resources"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of instance to create"
  type        = string
  default     = "t2.micro"
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Owner       = "Valerii Vasianovych"
    Project     = "AWS EC2 Ubuntu Instance Creation"
    Environment = "Development"
  }
}

variable "allow_security_groups_ports" {
  description = "The ports to open on the security group"
  type        = list(number)
  default     = [22, 80, 443]
}

# ── outputs.tf ────────────────────────────────────
output "aws_region" {
  value = data.aws_region.current.name
}

output "aws_region_description" {
  value = data.aws_region.current.description
}

output "aws_availability_zones" {
  value = data.aws_availability_zones.available
}

output "aws_caller_identity" {
  value = data.aws_caller_identity.current
}

# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

# ── security_group.tf ────────────────────────────────────
resource "aws_security_group" "lifecycle_security_group" {
  name        = "terraform_server"
  description = "An example security group for Terraform"

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
}