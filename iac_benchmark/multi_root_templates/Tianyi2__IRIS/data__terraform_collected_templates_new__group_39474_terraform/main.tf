terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  # required_version = ">= 1.2.0"
  # from terraform-unity
  #required_version = ">= 0.14.9"
  required_version = ">= 0.13.6"
}

provider "aws" {
  region = var.region
  profile = var.profile

  default_tags {
    tags = var.common_tags
  }
}
