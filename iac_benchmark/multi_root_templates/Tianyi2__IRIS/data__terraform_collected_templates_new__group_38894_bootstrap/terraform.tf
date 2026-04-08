terraform {
  backend "local" {
    path = "bootstrap.tfstate"
  }

  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.68"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Project = "terraform-monorepo-bootstrap"
    }
  }
}