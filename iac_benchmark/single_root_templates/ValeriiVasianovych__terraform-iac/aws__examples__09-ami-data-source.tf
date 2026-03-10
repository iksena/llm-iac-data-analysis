# ── main.tf ────────────────────────────────────
terraform {
    backend "s3" {
    bucket         = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terrafrom-tfstate-dynamodb"
    encrypt        = true
    key            = "aws/tfstates/ami_data-source/terraform.tfstate"
    region         = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# ── outputs.tf ────────────────────────────────────
output "latest_ubuntu_ami_id" {
  value = data.aws_ami.latest_ubuntu.id
}

output "latest_amazon_linux_ami_id" {
  value = data.aws_ami.latest_amazon_linux.id
}

output "latest_macos" {
  value = data.aws_ami.latest_macos.id
}

output "latest_windows_2022" {
  value = data.aws_ami.latest_windows.id
}


# ── datasource.tf ────────────────────────────────────
data "aws_ami" "latest_ubuntu" {
  owners      = ["099720109477"]
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

data "aws_ami" "latest_amazon_linux" {
  owners      = ["137112412989"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

data "aws_ami" "latest_macos" {
  owners      = ["628277914472"]
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn-ec2-macos-*-arm64"]
  }
}

data "aws_ami" "latest_windows" {
  owners      = ["801119661308"]
  most_recent = true
  filter {
    name   = "name"
    values = ["Windows_Server-2022-English-Full-SQL_2022_Standard-*"]
  }
}