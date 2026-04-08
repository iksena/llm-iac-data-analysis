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