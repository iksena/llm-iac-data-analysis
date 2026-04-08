data "aws_caller_identity" "current" {}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "terraform_remote_state" "global_vars" {
  backend = "s3"
  config = {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    key    = "aws/tfstates/examples/23-global-variables/globals/terraform.tfstate"
    region = "us-east-1"
  }
}