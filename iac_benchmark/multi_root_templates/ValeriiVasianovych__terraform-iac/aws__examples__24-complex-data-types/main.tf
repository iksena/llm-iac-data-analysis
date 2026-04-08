terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/24-complex-data-types/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "us-east-1"
}