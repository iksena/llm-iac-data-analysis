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
      CustodianRule    = "ecc-aws-370-workspaces_maintenance_mode_enabled"
      ComplianceStatus = "Green"
    }
  }
}