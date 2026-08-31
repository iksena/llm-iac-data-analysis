resource "aws_vpc" "sprint0_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = var.enable_dns_host
  enable_dns_support   = var.enable_dns_support

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

#internet gateway
resource "aws_internet_gateway" "sprint0_internet_gateway" {
  vpc_id = aws_vpc.sprint0_vpc.id

  tags = {
    Name = "${var.name_prefix}-internet_gateway"
  }
}

#elastic_ip
resource "aws_eip" "sprint0_eip" {
  domain     = var.eip_vpc ? "vpc" : null
  depends_on = [aws_internet_gateway.sprint0_internet_gateway]

  tags = {
    Name = "${var.name_prefix}-eip"
  }
}


# Route tables

resource "aws_route_table" "sprint0_public_rt" {
  vpc_id = aws_vpc.sprint0_vpc.id

  route {
    cidr_block = var.rt_public_cidr
    gateway_id = aws_internet_gateway.sprint0_internet_gateway.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rTable"
  }
}

resource "aws_default_route_table" "sprint0_private_rt" {
  default_route_table_id = aws_vpc.sprint0_vpc.default_route_table_id
  route {
    cidr_block     = var.rt_private_cidr
    nat_gateway_id = aws_nat_gateway.sprint0-nat.id
  }

  tags = {
    Name = "${var.name_prefix}-private-rTable"
  }
}

#-------  SUB NETS----------

resource "aws_subnet" "sprint0_public1_subnet" {
  vpc_id                  = aws_vpc.sprint0_vpc.id
  cidr_block              = var.cidrs["public1"]
  map_public_ip_on_launch = var.public_ip_map
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name_prefix}-_public1"
  }
}

resource "aws_subnet" "sprint0_public2_subnet" {
  vpc_id                  = aws_vpc.sprint0_vpc.id
  cidr_block              = var.cidrs["public2"]
  map_public_ip_on_launch = var.public_ip_map
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.name_prefix}-_public2"
  }
}

resource "aws_subnet" "sprint0_private1_subnet" {
  vpc_id                  = aws_vpc.sprint0_vpc.id
  cidr_block              = var.cidrs["private1"]
  map_public_ip_on_launch = var.private_ip_map
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name_prefix}-_private1"
  }
}

resource "aws_subnet" "sprint0_private2_subnet" {
  vpc_id                  = aws_vpc.sprint0_vpc.id
  cidr_block              = var.cidrs["private2"]
  map_public_ip_on_launch = var.private_ip_map
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "${var.name_prefix}-_private2"
  }
}

resource "aws_subnet" "sprint0_rds1_subnet" {
  vpc_id                  = aws_vpc.sprint0_vpc.id
  cidr_block              = var.cidrs["rds1"]
  map_public_ip_on_launch = var.rds_ip_map
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "${var.name_prefix}-_rds1"
  }
}

resource "aws_subnet" "sprint0_rds2_subnet" {
  vpc_id                  = aws_vpc.sprint0_vpc.id
  cidr_block              = var.cidrs["rds2"]
  map_public_ip_on_launch = var.rds_ip_map
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "${var.name_prefix}-_rds2"
  }
}

#NAT GATEWAY

resource "aws_nat_gateway" "sprint0-nat" {
  allocation_id = aws_eip.sprint0_eip.id
  subnet_id     = aws_subnet.sprint0_public1_subnet.id
  depends_on    = [aws_internet_gateway.sprint0_internet_gateway]

  tags = {
    Name = "${var.name_prefix}-nat"
  }
}


# Subnet Associations

resource "aws_route_table_association" "sprint0_public1_assoc" {
  subnet_id      = aws_subnet.sprint0_public1_subnet.id
  route_table_id = aws_route_table.sprint0_public_rt.id
}

resource "aws_route_table_association" "sprint0_public2_assoc" {
  subnet_id      = aws_subnet.sprint0_public2_subnet.id
  route_table_id = aws_route_table.sprint0_public_rt.id
}

resource "aws_route_table_association" "sprint0_private1_assoc" {
  subnet_id      = aws_subnet.sprint0_private1_subnet.id
  route_table_id = aws_default_route_table.sprint0_private_rt.id
}

resource "aws_route_table_association" "sprint0_private2_assoc" {
  subnet_id      = aws_subnet.sprint0_private2_subnet.id
  route_table_id = aws_default_route_table.sprint0_private_rt.id
}

resource "aws_db_subnet_group" "sprint0_rds_subnetgroup" {
  name = lower("${var.name_prefix}-subnetgroup-rds")

  subnet_ids = [
    aws_subnet.sprint0_rds1_subnet.id,
    aws_subnet.sprint0_rds2_subnet.id
  ]

  tags = {
    Name = "${var.name_prefix}-rds_subnetgroup"
  }
}
