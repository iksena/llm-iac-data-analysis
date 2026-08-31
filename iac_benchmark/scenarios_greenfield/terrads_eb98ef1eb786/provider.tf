terraform {
  required_version = "~> 1.7"

  required_providers {
    aws = {
      version = ">= 4.0, < 6.0"
      source  = "hashicorp/aws"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "2.4.2"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.2"
    }
  }
}

provider "aws" {
  region = var.region
}
