# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket         = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt        = true
    key            = "aws/tfstates/tf-s3/terraform.tfstate"
    region         = "us-east-1"
  }

  required_providers {
    aws = {
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = "default"
}

# ── variables.tf ────────────────────────────────────
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# ── outputs.tf ────────────────────────────────────
output "aws_region" {
  value = data.aws_region.current.name
}

output "aws_region_description" {
  value = data.aws_region.current.description
}

output "data_availability_zones" {
  value = data.aws_availability_zones.available.names
}

output "data_aws_caller_identity" {
  value = data.aws_caller_identity.current.account_id
}

# ── datasource.tf ────────────────────────────────────
data "aws_region" "current" {}
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

# ── vpc.tf ────────────────────────────────────
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"


  name            = "terraform.vpc"
  cidr            = "10.0.0.0/16"
  azs             = data.aws_availability_zones.available.names
  private_subnets = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  public_subnets  = ["10.0.20.0/24", "10.0.21.0/24", "10.0.22.0/24"]
  tags = {
    Account           = "Subnet in Account: ${data.aws_caller_identity.current.account_id}"
    Region            = "Subnet in Region: ${data.aws_region.current.name}"
    RegionDescription = "Region Description: ${data.aws_region.current.description}"
  }
}