terraform {
  backend "s3" {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    encrypt = true
    key     = "aws/tfstates/remote-tf-state/dev3/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
}

module "common_vars" {
  source = "../common"
}