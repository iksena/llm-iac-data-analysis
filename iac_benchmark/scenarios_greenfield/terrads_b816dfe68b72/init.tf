terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      # DS; terraform currently does not allow multiple versions of the same provider to be used in one project. So, even if you have multiple 
      # provider blocks, they must rely on the same provider version. Therefor, terraform suggests that for modules intended to be shared
      # one should specify the minimal possible version. After some searching, this is the minimal version supported by our current configs.
      version = ">= 4.9.0"
    }
  }
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}
