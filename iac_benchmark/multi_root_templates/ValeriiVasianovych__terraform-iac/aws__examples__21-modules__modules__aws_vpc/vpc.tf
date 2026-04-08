resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = merge(var.common_tags, {
    Name   = "${var.env}-vpc"
    Region = "Region: ${var.region}"
  })
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = merge(var.common_tags, {
    Name   = "${var.env}-igw"
    Region = "Region: ${var.region}"
  })
}