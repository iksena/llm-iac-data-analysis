terraform {
  backend "s3" {
    bucket = "terraform-monorepo.online.ntnu.no"
    key    = "prod/rds.tfstate"
    region = "eu-north-1"
  }

  required_version = "~> 1.14.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.13"
    }
    doppler = {
      source  = "DopplerHQ/doppler"
      version = "~> 1.11"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = "1.26.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"

  default_tags {
    tags = {
      Project     = "rds-prod"
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
      Project     = "rds-prod"
      Deployment  = "terraform"
      Repository  = "terraform-monorepo"
      Environment = "prod"
    }
  }
}

provider "postgresql" {
  host      = aws_db_instance.default.address
  port      = aws_db_instance.default.port
  username  = data.doppler_secrets.rds.map.USERNAME
  password  = data.doppler_secrets.rds.map.PASSWORD
  database  = aws_db_instance.default.db_name
  superuser = false
  sslmode   = "require"
}

variable "DOPPLER_TOKEN_ALL" {
  description = "TF Variable for the doppler service token"
  type        = string
}

provider "doppler" {
  doppler_token = var.DOPPLER_TOKEN_ALL
}
