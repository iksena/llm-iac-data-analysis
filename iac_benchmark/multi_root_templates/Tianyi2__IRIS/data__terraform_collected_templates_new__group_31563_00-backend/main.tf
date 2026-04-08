provider "aws" {
  region = var.region

  default_tags {
    tags = var.tags
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}