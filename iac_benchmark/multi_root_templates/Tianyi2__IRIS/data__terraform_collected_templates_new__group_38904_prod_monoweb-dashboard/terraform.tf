terraform {
  backend "s3" {
    bucket = "terraform-monorepo.online.ntnu.no"
    key    = "prod/monoweb-dashboard.tfstate"
    region = "eu-north-1"
  }

  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13"
    }
    sentry = {
      source  = "jianyuan/sentry"
      version = "0.14.8"
    }
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.11"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Project     = "dashboard-prod"
      Deployment  = "terraform"
      Repository  = "terraform-monorepo"
      Environment = "prod"
    }
  }
}

provider "aws" {
  alias  = "us-east-1"
  region = "us-east-1"

  default_tags {
    tags = {
      Project     = "dashboard-prod"
      Deployment  = "terraform"
      Repository  = "terraform-monorepo"
      Environment = "prod"
    }
  }
}

provider "sentry" {}

variable "DOPPLER_TOKEN_ALL" {
  description = "TF Variable for the doppler service token"
  type        = string
}

provider "doppler" {
  doppler_token = var.DOPPLER_TOKEN_ALL
}
