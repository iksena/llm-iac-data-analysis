# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/aws-instance-vpc/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  allow_sg_ports     = var.allow_sg_ports
  common_tags        = var.common_tags
}

# module "ec2" {
#   source            = "./modules/ec2"
#   instance_ami      = data.aws_ami.latest_ubuntu.id
#   instance_type     = var.instance_type
#   security_group_id = module.network.security_group_id
#   subnet_id         = module.network.public_subnet_id
#   common_tags       = var.common_tags
# }

# ── variables.tf ────────────────────────────────────
variable "region" {
  description = "AWS region to deploy instance"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "Public subnet cird block for VPC"
  type        = string
  default     = "10.0.10.0/24"
}

variable "instance_type" {
  description = "Definition of instance type for EC2"
  type        = string
  default     = "t2.micro"
}

variable "allow_sg_ports" {
  description = "Allow HTTP, HTTPS, SSH ports"
  type        = list(number)
  default     = [80, 443, 22]
}

variable "common_tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Owner       = "Valerii Vasianovych"
    Project     = "AWS Instance Creation"
    Environment = "Development"
  }
}

# ── outputs.tf ────────────────────────────────────
output "current_region" {
  value = data.aws_region.current.name
}

output "aws_account_id" {
  value = data.aws_caller_identity.current.id
}

# output "instance_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = module.ec2.instance_public_ip
# }

output "vpc_id" {
  description = "VPC ID"
  value       = module.network.vpc_id
}


# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

# ── provider.tf ────────────────────────────────────
provider "aws" {
  region = var.region
}