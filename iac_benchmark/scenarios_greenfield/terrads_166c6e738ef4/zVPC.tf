##  Create VPC
resource "aws_vpc" "webhost_vpc" {
    cidr_block = var.VPC_CIDR
    tags = {
      "Name" = "${var.AWS_ENV}_vpc"
      "Env" = var.AWS_ENV
    }
}

#  Create Public Subnets
resource "aws_subnet" "webhost_public_subnet" {
    vpc_id = aws_vpc.webhost_vpc.id
    cidr_block = var.PUBLIC_CIDR
    tags = {
      "Name" = "${var.AWS_ENV}_public",
      "Env" = var.AWS_ENV
    }
}

#  Create Private Subnets
resource "aws_subnet" "webhost_private_subnet" {
    vpc_id = aws_vpc.webhost_vpc.id
    cidr_block = var.PRIVATE_CIDR
    tags = {
      "Name" = "${var.AWS_ENV}_private",
      "Env" = var.AWS_ENV
    }
}






