data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    encrypt = true
    key     = "aws/tfstates/remote-tf-state/dev1/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "terraform_remote_state" "ec2" {
  backend = "s3"
  config = {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    encrypt = true
    key     = "aws/tfstates/remote-tf-state/dev2/terraform.tfstate"
    region  = "us-east-1"
  }
}