terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source = "hashicorp/aws"
      #  Allow any 3.22+  version of the AWS provider
      version = "= 3.44"
    }
    null = {
      source  = "hashicorp/null"
      version = "= 3.1.0"
    }
    external = {
      source  = "hashicorp/external"
      version = "= 2.1.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "= 2.3.1"
    }

  }
}

provider "aws" {
  region                  = "eu-west-1"
  shared_credentials_file = "~/.aws/credentials"
  profile                 = "default"
}
provider "null" {}
provider "external" {}

