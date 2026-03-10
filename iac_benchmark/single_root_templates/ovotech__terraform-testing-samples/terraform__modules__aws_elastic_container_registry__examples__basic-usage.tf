# ── main.tf ────────────────────────────────────
module "ecr" {
  source  = "app.terraform.io/ovotech/container-registry/aws"
  version = "1.0.0"

  ecr_name = "my-container-registry"
}


# ── versions.tf ────────────────────────────────────
terraform {
  required_version = "~> 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.75"
    }
  }
}

provider "aws" {
  region = "eu-west-1"

  default_tags {
    tags = {
      Deletable = "True"
      Creator   = "Terratest"
    }
  }
}
