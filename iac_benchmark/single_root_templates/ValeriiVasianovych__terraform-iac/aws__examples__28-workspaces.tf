# ── main.tf ────────────────────────────────────
terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/examples/28-workdspaces/terraform.tfstate"
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
        Environment = "${terraform.workspace}"
    }
  }
}

# ── variables.tf ────────────────────────────────────
variable "region" {
  default = "us-east-1"
}

# ── outputs.tf ────────────────────────────────────


# ── eip.tf ────────────────────────────────────
resource "aws_eip" "eip" {
    instance = aws_instance.instance-ec2.id
  tags = {
    Name = "EIP-${terraform.workspace}"
  }
}

# ── instance.tf ────────────────────────────────────
resource "aws_instance" "instance-ec2" {
  ami = "ami-084568db4383264d4"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.sg.id]
  tags = {
    Name = "Instance-${terraform.workspace}" 
  }
}

# ── sg.tf ────────────────────────────────────
resource "aws_security_group" "sg" {
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
    Name  = "SG-${terraform.workspace}"
  }
}