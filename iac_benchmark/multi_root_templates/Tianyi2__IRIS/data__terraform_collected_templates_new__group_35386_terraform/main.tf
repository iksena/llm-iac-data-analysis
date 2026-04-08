terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.67.0"
    }
  }

  required_version = ">= 1.2.0"

  backend "s3" {
    bucket  = "tf-state-paraguay-public-servant"
    key     = "paraguay-public-servant-dev.tfstate"
    region  = "us-east-1"
    encrypt = true
  }

}

provider "aws" {
  region = var.aws_region
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
