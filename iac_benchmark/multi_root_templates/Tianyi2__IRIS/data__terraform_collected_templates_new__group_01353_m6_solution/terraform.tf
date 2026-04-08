terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }

  backend "s3" {
    bucket = "<SET TO YOUR BUCKET NAME>"
    region = "us-east-1"
    
  }
}