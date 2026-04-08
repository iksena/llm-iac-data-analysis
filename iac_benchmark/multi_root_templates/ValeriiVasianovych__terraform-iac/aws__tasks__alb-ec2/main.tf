terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/tasks/alb-ec2/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region
  default_tags {
    tags = {
        Environment = var.env
        Owner = "Valerii Vasianovych"
        Project = "ALB Project"
    }
  }
}

resource "aws_eip" "alb_eip" {
  count = 1
  tags = {
    Name = "alb-eip-${count.index + 1}-${var.env}"
  }
  
}