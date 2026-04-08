provider "aws" {
  region = var.vpc_region_1
  alias  = "vpc-1"
}

resource "aws_vpc" "vpc-1" {
  cidr_block = var.vpc_cidr_1
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.common_tags, {
    Name = "vpc-1"
  })
}

resource "aws_internet_gateway" "igw-1" {
  vpc_id = aws_vpc.vpc-1.id
  tags = merge(var.common_tags, {
    Name = "igw-${local.vpc_1_name}"
  })
}

resource "aws_subnet" "subnet-1" {
  provider   = aws.vpc-1
  vpc_id     = aws_vpc.vpc-1.id
  cidr_block = var.subnet_cidr_1
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, {
    Name = "subnet-${local.vpc_1_name}"
  })
}

resource "aws_route_table" "vpc_1_igw" {
  provider = aws.vpc-1
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-1.id
  }
    tags = merge(var.common_tags, {
        Name = "route-table-${local.vpc_1_name}"
    })
}

resource "aws_route" "vpc_1_to_vpc_2" {
  provider = aws.vpc-1
  route_table_id = aws_route_table.vpc_1_igw.id
  destination_cidr_block = var.vpc_cidr_2
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route_table_association" "subnet_1_association" {
  provider = aws.vpc-1
  subnet_id = aws_subnet.subnet-1.id
  route_table_id = aws_route_table.vpc_1_igw.id
}