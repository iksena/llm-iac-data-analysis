locals {
  aws_region  = "us-east-1"
  prefix      = "private-fargate-crowdnews"
  common_tags = {
    Project         = local.prefix
    ManagedBy       = "Terraform"
  }
  vpc_cidr = "10.0.0.0/16"
}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
