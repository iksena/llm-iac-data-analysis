terraform {
  backend "s3" {
    bucket = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/lifecycles/terraform.tfstate"
    region  = "us-east-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "lifecycle_instance" {
  ami                    = "ami-07d9b9ddc6cd8dd30"
  instance_type          = var.instance_type
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.lifecycle_security_group.id]

  # Lifecycle rules for instance
  lifecycle {
    # Uncomment below lines to prevent instance from being destroyed or to ignore changes to specified attributes
    # prevent_destroy = true
    # ignore_changes  = [ami, instance_type]
  }

  tags = merge(var.common_tags, {
  })
}
