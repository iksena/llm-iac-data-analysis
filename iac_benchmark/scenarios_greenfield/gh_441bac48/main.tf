terraform {
  required_providers {
    aws = {
      source                = "hashicorp/aws"
    }
  }
}

provider "aws" {
  alias  = "replication"
  region = "us-west-2"
}

data "aws_caller_identity" "current" {}

data "aws_region" "main" {}

data "aws_region" "replication" {
  provider = aws.replication
}
