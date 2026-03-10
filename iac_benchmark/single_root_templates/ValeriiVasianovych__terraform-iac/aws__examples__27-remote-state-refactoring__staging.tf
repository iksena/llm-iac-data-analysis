# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/27-remote-state-refactoring/staging/terraform.tfstate"
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

# ── instance-staging.tf ────────────────────────────────────
resource "aws_instance" "instance-2" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg-2.id]
  tags = {
    Name = "Instance-2"
    Environment = "Staging"
  }
}

# ── sg-staging.tf ────────────────────────────────────
resource "aws_security_group" "sg-2" {
  name        = "http-https-sg"
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
    Name  = "SG-2"
    Environment = "Staging"
  }
}