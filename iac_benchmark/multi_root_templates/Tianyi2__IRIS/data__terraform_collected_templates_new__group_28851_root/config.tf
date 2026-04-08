terraform {
  required_version = ">= 0.13.5"

  # Normally I would use an S3 remote state backend with 
  # DynamoDB state locking, configured in a separate folder.
  # However, I do not have time to implement this.

  # An interesting solution to the chicken-and-egg problem of
  # setting up state backends in Terraform can be seen at
  # https://github.com/thefunkjunky/gcloud-takehome/tree/main/00-backend.
  # It is configured for Google Cloud, but the idea is similar.
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "3.71.0"
    }
  }
}

provider "aws" {
  region = var.region
}
