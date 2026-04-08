terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/27-remote-state-refactoring/production/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
        Project = "Terraform state refactoring"
        Owner = "Valerii Vasianovych"
    }
  }
}