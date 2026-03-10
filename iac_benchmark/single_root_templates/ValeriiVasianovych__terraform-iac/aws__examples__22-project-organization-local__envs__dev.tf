# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/local-modules-dev/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
}

module "vpc" {
  source               = "../../modules/vpc"
  region               = var.region
  env                  = var.env
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  common_tags          = var.common_tags
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "public_subnet_cidrs" {
  default = [
    "192.168.10.0/24"
  ]
}

variable "private_subnet_cidrs" {
  default = [
    "192.168.20.0/24"
  ]
}

variable "common_tags" {
  default = {
    Owner : "Valerii Vasianovych"
    Project : "Terraform AWS"
  }
}

# ── outputs.tf ────────────────────────────────────
output "region" {
  value = module.vpc.region
}

output "account_id" {
  value = module.vpc.account_id
}

output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnet_cidrs" {
  value = module.vpc.public_subnet_cidrs
}

output "private_subnet_cidrs" {
  value = module.vpc.private_subnet_cidrs
}