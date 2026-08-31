# Self-contained VPC, used only when ec2_vpc_id is left at its default (blank) value.
resource "aws_vpc" "benchmark" {
  count      = var.ec2_vpc_id == "" ? 1 : 0
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "benchmark-vpc"
  }
}

resource "aws_internet_gateway" "benchmark" {
  count  = var.ec2_vpc_id == "" ? 1 : 0
  vpc_id = aws_vpc.benchmark[0].id
}

locals {
  effective_ec2_vpc_id = var.ec2_vpc_id != "" ? var.ec2_vpc_id : aws_vpc.benchmark[0].id
}

data "aws_ami" "amazon_linux_2" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}
