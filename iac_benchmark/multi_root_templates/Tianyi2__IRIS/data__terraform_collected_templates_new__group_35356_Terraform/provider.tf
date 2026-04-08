terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    bucket = "full-scale-app-automation-cicd"
    key    = "aws/flaskapp-ec2-deploy/portfolio-terraform.tfstate"
    region = "us-east-1"
  }
  required_version = "~> 1.7"
}

provider "aws" {
  region = "us-east-1"
}