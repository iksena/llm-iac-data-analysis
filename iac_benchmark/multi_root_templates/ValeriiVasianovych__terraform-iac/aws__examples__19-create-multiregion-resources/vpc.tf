resource "aws_vpc" "vpc-1" {
  provider   = aws.region-1
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "VPC-${var.region_name[0]}"
  }
}

resource "aws_vpc" "vpc-2" {
  provider   = aws.region-2
  cidr_block = "192.168.0.0/16"
  tags = {
    Name = "VPC-${var.region_name[1]}"
  }
}

resource "aws_vpc" "vpc-3" {
  provider   = aws.region-3
  cidr_block = "172.16.0.0/16"
  tags = {
    Name = "VPC-${var.region_name[2]}"
  }
}