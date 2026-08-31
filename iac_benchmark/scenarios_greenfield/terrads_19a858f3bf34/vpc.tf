locals {
  vpc_tags = {
  }
}

# VPC

resource "aws_vpc" "dit_paas_cluster" {
  cidr_block = "${var.vpc_cidr_network_octets}.0.0/16"
  enable_dns_hostnames = false
  tags = {"Name" = "dit-paas-${var.cluster_name}-cluster-vpc"} 
}


# Private Subnets

resource "aws_subnet" "dit_paas_cluster_private_a" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  cidr_block = "${var.vpc_cidr_network_octets}.0.0/22"
  availability_zone = "${var.aws_region}a"
  tags = merge(
    {
      "Name" = "dit-paas-${var.cluster_name}-private-a",
      "Subnet" = "dit-paas-${var.cluster_name}-private",
      "Subnet_class" = "private",
      "Availability_zone" = "${var.aws_region}a"
      "Cluster" = "dit-paas-${var.cluster_name}"
      "Cluster_name" = var.cluster_name
    },
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_subnet" "dit_paas_cluster_private_b" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  cidr_block = "${var.vpc_cidr_network_octets}.4.0/22"
  availability_zone = "${var.aws_region}b"
  tags = merge(
    {
      "Name" = "dit-paas-${var.cluster_name}-private-b",
      "Subnet" = "dit-paas-${var.cluster_name}-private",
      "Subnet_class" = "private",
      "Availability_zone" = "${var.aws_region}b"
      "Cluster" = "dit-paas-${var.cluster_name}"
      "Cluster_name" = var.cluster_name
    },
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_subnet" "dit_paas_cluster_private_c" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  cidr_block = "${var.vpc_cidr_network_octets}.8.0/22"
  availability_zone = "${var.aws_region}c"
  tags = merge(
    {
      "Name" = "dit-paas-${var.cluster_name}-private-c",
      "Subnet" = "dit-paas-${var.cluster_name}-private",
      "Subnet_class" = "private",
      "Availability_zone" = "${var.aws_region}c"
      "Cluster" = "dit-paas-${var.cluster_name}"
      "Cluster_name" = var.cluster_name
    },
    var.default_tags,
    local.vpc_tags
  )
}

# Private Routing

resource "aws_route" "private_route_a" {
  route_table_id         = aws_route_table.private_a.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_a.id
}

resource "aws_route_table" "private_a" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  tags = merge(
    {"Name" = "${var.cluster_name}-private-a"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route_table_association" "private_a" {
  subnet_id      = aws_subnet.dit_paas_cluster_private_a.id
  route_table_id = aws_route_table.private_a.id
}

resource "aws_route" "private_route_b" {
  route_table_id         = aws_route_table.private_b.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_b.id
}

resource "aws_route_table" "private_b" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  tags = merge(
    {"Name" = "${var.cluster_name}-private-b"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route_table_association" "private_b" {
  subnet_id      = aws_subnet.dit_paas_cluster_private_b.id
  route_table_id = aws_route_table.private_b.id
}

resource "aws_route" "private_route_c" {
  route_table_id         = aws_route_table.private_c.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.public_c.id
}

resource "aws_route_table" "private_c" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  tags = merge(
    {"Name" = "${var.cluster_name}-private-c"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route_table_association" "private_c" {
  subnet_id      = aws_subnet.dit_paas_cluster_private_c.id
  route_table_id = aws_route_table.private_c.id
}

# NAT Gateways

resource "aws_eip" "public_a" {
  domain = "vpc"
  tags = merge(
    {"Name" = "${var.cluster_name}-eip-nat-a"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_nat_gateway" "public_a" {
  allocation_id = aws_eip.public_a.id
  subnet_id     = aws_subnet.dit_paas_cluster_public_a.id
  tags = merge(
    {"Name" = "${var.cluster_name}-nat-gateway-a"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_eip" "public_b" {
  domain = "vpc"
  tags = merge(
    {"Name" = "${var.cluster_name}-eip-nat-b"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_nat_gateway" "public_b" {
  allocation_id = aws_eip.public_b.id
  subnet_id     = aws_subnet.dit_paas_cluster_public_b.id
  tags = merge(
    {"Name" = "${var.cluster_name}-nat-gateway-b"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_eip" "public_c" {
  domain = "vpc"
  tags = merge(
    {"Name" = "${var.cluster_name}-eip-nat-c"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_nat_gateway" "public_c" {
  allocation_id = aws_eip.public_c.id
  subnet_id     = aws_subnet.dit_paas_cluster_public_c.id
  tags = merge(
    {"Name" = "${var.cluster_name}-nat-gateway-c"},
    var.default_tags,
    local.vpc_tags
  )
}


# Public Subnets

resource "aws_subnet" "dit_paas_cluster_public_a" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  cidr_block = "${var.vpc_cidr_network_octets}.12.0/22"
  availability_zone = "${var.aws_region}a"
  tags = merge(
    {
      "Name" = "dit-paas-${var.cluster_name}-public-a",
      "Subnet" = "dit-paas-${var.cluster_name}-public",
      "Subnet_class" = "public",
      "Availability_zone" = "${var.aws_region}a"
      "Cluster" = "dit-paas-${var.cluster_name}"
      "Cluster_name" = var.cluster_name
    },
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_subnet" "dit_paas_cluster_public_b" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  cidr_block = "${var.vpc_cidr_network_octets}.16.0/22"
  availability_zone = "${var.aws_region}b"
  tags = merge(
    {
      "Name" = "dit-paas-${var.cluster_name}-public-b",
      "Subnet" = "dit-paas-${var.cluster_name}-public",
      "Subnet_class" = "public",
      "Availability_zone" = "${var.aws_region}b"
      "Cluster" = "dit-paas-${var.cluster_name}"
      "Cluster_name" = var.cluster_name
    },
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_subnet" "dit_paas_cluster_public_c" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  cidr_block = "${var.vpc_cidr_network_octets}.20.0/22"
  availability_zone = "${var.aws_region}c"
  tags = merge(
    {
      "Name" = "dit-paas-${var.cluster_name}-public-c",
      "Subnet" = "dit-paas-${var.cluster_name}-public",
      "Subnet_class" = "public",
      "Availability_zone" = "${var.aws_region}c"
      "Cluster" = "dit-paas-${var.cluster_name}"
      "Cluster_name" = var.cluster_name
    },
    var.default_tags,
    local.vpc_tags
  )
}

# Public Routing

resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.dit_paas_cluster_public.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  tags = merge(
    {"Name" = "${var.cluster_name}-public"},
    var.default_tags,
    local.vpc_tags
  )
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.dit_paas_cluster_public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.dit_paas_cluster_public_b.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.dit_paas_cluster_public_c.id
  route_table_id = aws_route_table.public.id
}

resource "aws_internet_gateway" "dit_paas_cluster_public" {
  vpc_id = aws_vpc.dit_paas_cluster.id
  tags = merge(
    {"Name" = "${var.cluster_name}-ig"},
    var.default_tags,
    local.vpc_tags
  )
}
