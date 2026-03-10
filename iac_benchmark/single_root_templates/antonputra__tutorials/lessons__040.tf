# ── main.tf ────────────────────────────────────
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
# Resource: aws_instance

resource "aws_instance" "server" {
  # The AMI to use for the instance.
  ami = var.ami

  # The type of instance to start.
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [tags]
  }
}

# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip
# Resource: aws_eip

resource "aws_eip" "ip" {
  vpc      = true
  instance = aws_instance.server.id
}


# ── variables.tf ────────────────────────────────────
variable "ami" {
  default = "ami-0ac73f33a1888c64a"
}


# ── output.tf ────────────────────────────────────
output "ip" {
  value = aws_eip.ip.public_ip
}


# ── provider.tf ────────────────────────────────────
provider "aws" {
  region  = "us-west-2"
  profile = "terraform"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  backend "s3" {
    profile = "terraform"
    bucket = "antonputra-tfstate"
    key    = "services/server.tfstate"
    region = "us-west-2"
    dynamodb_table = "tfstate"
  }
}
