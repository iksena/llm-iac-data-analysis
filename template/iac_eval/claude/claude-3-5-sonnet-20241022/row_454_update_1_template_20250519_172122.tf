provider "aws" {
  region = "us-west-2"
}

# Create the first VPC (peer)
resource "aws_vpc" "peer" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "peer"
  }
}

# Create the second VPC (base)
resource "aws_vpc" "base" {
  cidr_block           = "172.16.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "base"
  }
}

# Create VPC peering connection
resource "aws_vpc_peering_connection" "pike" {
  peer_vpc_id = aws_vpc.peer.id
  vpc_id      = aws_vpc.base.id
  auto_accept = true

  tags = {
    Name = "pike"
    pike = "permissions"
  }
}

# Create route table for peer VPC
resource "aws_route_table" "peer_route_table" {
  vpc_id = aws_vpc.peer.id

  route {
    cidr_block                = aws_vpc.base.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
  }

  tags = {
    Name = "peer-route-table"
  }
}

# Create route table for base VPC
resource "aws_route_table" "base_route_table" {
  vpc_id = aws_vpc.base.id

  route {
    cidr_block                = aws_vpc.peer.cidr_block
    vpc_peering_connection_id = aws_vpc_peering_connection.pike.id
  }

  tags = {
    Name = "base-route-table"
  }
}

# Associate route table with peer VPC
resource "aws_main_route_table_association" "peer_route_association" {
  vpc_id         = aws_vpc.peer.id
  route_table_id = aws_route_table.peer_route_table.id
}

# Associate route table with base VPC
resource "aws_main_route_table_association" "base_route_association" {
  vpc_id         = aws_vpc.base.id
  route_table_id = aws_route_table.base_route_table.id
}