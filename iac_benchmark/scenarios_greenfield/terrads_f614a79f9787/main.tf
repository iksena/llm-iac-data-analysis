## Main ##

terraform {
  required_version      = ">= 0.13"
  required_providers {
    aws                 = ">= 3.37.0"
  }
}

provider "aws" {
  profile               = var.aws_profile
  region                = var.aws_region
}

locals {
  # Common tags to be assigned to resources
  common_tags           = {
    Application         = var.app_name
    Environment         = var.aws_env
  }

}
