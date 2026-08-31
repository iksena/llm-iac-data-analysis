# Project: Frankfurt-VPC
#
# VPC Module

# # VPC # #
resource "aws_vpc" "frankfurt_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.tenancy

  tags = var.vpc_tags
}

# # Public Subnets # #
resource "aws_subnet" "frankfurt_public_subnet" {
  count = length(var.public_subnet_cidr)

  vpc_id            = aws_vpc.frankfurt_vpc.id
  cidr_block        = element(var.public_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "frankfurt-public-subnet-${count.index + 1}"
    Environment = "Prod"
  }
}

# # Private Subnets # #
resource "aws_subnet" "frankfurt_private_subnet" {
  count = length(var.private_subnet_cidr)

  vpc_id            = aws_vpc.frankfurt_vpc.id
  cidr_block        = element(var.private_subnet_cidr, count.index)
  availability_zone = element(var.availability_zones, count.index)

  tags = {
    Name        = "frankfurt-private-subnet-${count.index + 1}"
    Environment = "Prod"
  }
}

# # Internet Gateway # #
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.frankfurt_vpc.id
  tags = {
    Name        = "internet-gateway"
    Environment = "Prod"
  }
}

# # Public Route Table # #
resource "aws_route_table" "route_table" {
  vpc_id = aws_vpc.frankfurt_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name        = "frankfurt-public-route-table"
    Environment = "Prod"
  }
}

# # Route Table Association # #
resource "aws_route_table_association" "rt_association" {
  count     = length(var.public_subnet_cidr)
  subnet_id = element(aws_subnet.frankfurt_public_subnet.*.id, count.index)

  route_table_id = aws_route_table.route_table.id
}

# # Network ACL # #
resource "aws_network_acl" "nacl" {
  vpc_id = aws_vpc.frankfurt_vpc.id
  subnet_ids = aws_subnet.frankfurt_public_subnet.*.id

  dynamic "ingress" {
    for_each = var.nacl_ingress

    content {
      protocol   = ingress.value["protocol"]
      rule_no    = ingress.value["rule_no"]
      action     = ingress.value["action"]
      cidr_block = ingress.value["cidr_block"]
      from_port  = ingress.value["from_port"]
      to_port    = ingress.value["to_port"]
    }
  }

  dynamic "egress" {
    for_each = var.nacl_egress

    content {
      protocol   = egress.value["protocol"]
      rule_no    = egress.value["rule_no"]
      action     = egress.value["action"]
      cidr_block = egress.value["cidr_block"]
      from_port  = egress.value["from_port"]
      to_port    = egress.value["to_port"]
    }
  }
}
