terraform {
  required_version = ">= 1.4.0"

  required_providers {
    aws = {
      source                = "hashicorp/aws"
      version               = ">= 5.26.0"
      configuration_aliases = [aws.iam]
    }
    terraform = {
      source = "terraform.io/builtin/terraform"
    }
  }
}
 