# ── main.tf ────────────────────────────────────
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

# ── variables.tf ────────────────────────────────────
variable "region" {
  default = "us-east-1"
}

# ── instance-prod.tf ────────────────────────────────────

resource "aws_instance" "instance-1" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg-1.id]
  tags = {
    Name = "Instance-1"
    Environment = "Production"
  }
}

# ── sg-forgotted.tf ────────────────────────────────────
resource "aws_security_group" "sg-forgotted" {
  name        = "sg_forgotted"
  description = "Allows HTTP HTTPS"
  dynamic "ingress" {
    for_each = [80, 443]
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
  tags = {
    Name  = "SG-test-forgotted"
    Environment = "Test"
  }
}
# resource "aws_security_group" "sg-2-test" {
#   name        = "sg_test_two"
#   description = "Allows HTTP HTTPS"
#   dynamic "ingress" {
#     for_each = [80, 443]
#     content {
#       from_port   = ingress.value
#       to_port     = ingress.value
#       protocol    = "tcp"
#       cidr_blocks = ["0.0.0.0/0"]
#     }
#   }
#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }
#   tags = {
#     Name  = "SG-test-1"
#     Environment = "Test"
#   }
# }

# ── sg-prod.tf ────────────────────────────────────
resource "aws_security_group" "sg-1" {
  name        = "http-ssh-sg"
  description = "Allows HTTP SSH"

  dynamic "ingress" {
    for_each = [80, 22]
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
  tags = {
    Name  = "SG-1"
    Environment = "Production"
  }
}