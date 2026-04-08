terraform {

  required_version = ">= 1.2.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  backend "s3" {
    bucket = "efcunha-remote-state"
    key    = "aws-vpc-provider/terraform.tfstate"
    region = "us-west-2"
  }
}

provider "aws" {
  region = "us-west-2"

  default_tags {
    tags = {
      owner      = "efcunha"
      managed-by = "terraform"
      region     = "us-west-2"
    }
  }
}

provider "aws" {
  alias  = "eua"
  region = "us-east-1"

  default_tags {
    tags = {
      owner      = "efcunha"
      managed-by = "terraform"
      region     = "us-east-1"
    }
  }
}