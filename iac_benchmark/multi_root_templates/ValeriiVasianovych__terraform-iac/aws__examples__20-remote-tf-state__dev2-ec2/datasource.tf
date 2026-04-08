data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    encrypt = true
    key     = "aws/tfstates/remote-tf-state/dev1/terraform.tfstate"
    region  = "us-east-1"
  }
}

data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}
  