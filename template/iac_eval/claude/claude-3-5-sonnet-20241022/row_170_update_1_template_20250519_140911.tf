provider "aws" {
  region = "us-west-2"
}

# Create VPC
resource "aws_vpc" "dax_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "dax-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "dax_igw" {
  vpc_id = aws_vpc.dax_vpc.id

  tags = {
    Name = "dax-igw"
  }
}

# Create Private Subnet 1
resource "aws_subnet" "private_subnet_1" {
  vpc_id            = aws_vpc.dax_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "dax-private-subnet-1"
  }
}

# Create Private Subnet 2
resource "aws_subnet" "private_subnet_2" {
  vpc_id            = aws_vpc.dax_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2b"

  tags = {
    Name = "dax-private-subnet-2"
  }
}

# Create Route Table
resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.dax_vpc.id

  tags = {
    Name = "dax-private-route-table"
  }
}

# Associate Route Table with Subnet 1
resource "aws_route_table_association" "private_route_1" {
  subnet_id      = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_route_table.id
}

# Associate Route Table with Subnet 2
resource "aws_route_table_association" "private_route_2" {
  subnet_id      = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_route_table.id
}

# Create DAX Subnet Group
resource "aws_dax_subnet_group" "dax_subnet_group" {
  name        = "dax-subnet-group"
  subnet_ids  = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id]

  tags = {
    Name = "dax-subnet-group"
  }
}