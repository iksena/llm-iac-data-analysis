terraform {
  backend "s3" {
    bucket = "terraform-monorepo.online.ntnu.no"
    key    = "prod/evergreen.tfstate"
    region = "eu-north-1"
  }

  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Project     = "evergreen-prod"
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
      Project     = "evergreen-prod"
      Deployment  = "terraform"
      Repository  = "terraform-monorepo"
      Environment = "prod"
    }
  }
}
