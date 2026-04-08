terraform {
  backend "s3" {
    bucket  = "terrafrom-tfstate-file-s3-bucket"
    # dynamodb_table = "terraform-tfstate-dynamodb"
    encrypt = true
    key     = "aws/tfstates/outputs/terraform.tfstate"
    region  = "us-east-1"
  }
  required_providers {
	aws = {
	  source = "hashicorp/aws"
	  version = "~> 4.16"
	}
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_eip" "static_ip" {
  instance = aws_instance.little_downtime.id
  }



resource "aws_instance" "little_downtime" {
  ami                    = "ami-04b70fa74e45c3917"
  instance_type          = "t2.micro"
  key_name               = "ServersKey"
  vpc_security_group_ids = [aws_security_group.lifecycle_security_group.id]
  user_data              = file("script.sh")

  tags = {
    Name    = "LifecycleElasticServer"
    Owner   = "Valerii Vasianovych"
    Project = "AWS Instance Creation with Terraform and dyn amic template"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_security_group" "lifecycle_security_group" {
  name        = "lifecycle_security_group"
  description = "An example security group for Terraform"

  dynamic "ingress" {
    for_each = ["80", "443", "22"]

    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}