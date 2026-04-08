# main.tf (Root Module)
# Corrected version

terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

# Data Source to get available AZs
data "aws_availability_zones" "available" {
  state = "available"
}

# VPC Module
module "vpc" {
  source = "./modules/vpc"

  vpc_cidr            = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  availability_zones  = slice(data.aws_availability_zones.available.names, 0, 2)
  project_name        = var.project_name
}

# Security Group Module
module "security_group" {
  source = "./modules/security-groups"

  vpc_id       = module.vpc.vpc_id
  project_name = var.project_name
}

# EC2 instance Module
module "ec2" {
  source = "./modules/ec2"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  subnet_ids        = module.vpc.public_subnet_ids  # ✅ FIXED: Changed from public_subnet_cidrs
  security_group_id = module.security_group.ec2_security_group_id
  project_name      = var.project_name
  key_name          = var.key_name
}

# Application Load Balancer Module
module "alb" {
  source = "./modules/alb"

  vpc_id            = module.vpc.vpc_id
  subnet_ids        = module.vpc.public_subnet_ids  # ✅ FIXED: Changed from public_subnet_cidrs
  security_group_id = module.security_group.alb_security_group_id
  instance_ids      = module.ec2.instance_ids
  project_name      = var.project_name
}
