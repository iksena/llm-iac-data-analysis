### Terraform Provider Declaration ### 
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}
### Terraform Provider AWS ###
provider "aws" {
  region = var.AWS_REGION
}