terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.11.0"
    }
  }

  required_version = ">= 0.12"
}

provider "aws" {
  region = "eu-central-1"

  default_tags {
    tags = {
      Env   = "Dev"
      Owner = "TFProviders"
    }
  }
}
