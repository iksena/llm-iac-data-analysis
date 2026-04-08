provider "aws" {
  region = var.vpc_region_2
  alias  = "vpc-2"
}

resource "aws_vpc" "vpc-2" {
  provider = aws.vpc-2
  cidr_block = var.vpc_cidr_2
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = merge(var.common_tags, {
    Name = "vpc-2"
  })
}

resource "aws_internet_gateway" "igw-2" {
  provider = aws.vpc-2
  vpc_id = aws_vpc.vpc-2.id
  tags = merge(var.common_tags, {
    Name = "igw-${local.vpc_2_name}"
  })
}

resource "aws_subnet" "subnet-2" {
  provider   = aws.vpc-2
  vpc_id     = aws_vpc.vpc-2.id
  cidr_block = var.subnet_cidr_2
  map_public_ip_on_launch = true
  tags = merge(var.common_tags, {
    Name = "subnet-${local.vpc_2_name}"
  })
}

resource "aws_route_table" "vpc_2_igw" {
  provider = aws.vpc-2
  vpc_id = aws_vpc.vpc-2.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw-2.id
    }
    tags = merge(var.common_tags, {
        Name = "route-table-${local.vpc_2_name}"
    })
}

resource "aws_route" "vpc_2_to_vpc_1" {
  provider = aws.vpc-2
  route_table_id = aws_route_table.vpc_2_igw.id
  destination_cidr_block = var.vpc_cidr_1
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_peering.id
}

resource "aws_route_table_association" "subnet_2_association" {
  provider = aws.vpc-2
  subnet_id = aws_subnet.subnet-2.id
  route_table_id = aws_route_table.vpc_2_igw.id
}

