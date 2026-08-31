terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4"
    }
  }
}

provider "aws" {
  region  = var.default-region

  default_tags {
    tags = {
      CustodianRule    = "ecc-aws-465-fsx_daily_automatic_backup_enabled"
      ComplianceStatus = "Green"
    }
  }
}
