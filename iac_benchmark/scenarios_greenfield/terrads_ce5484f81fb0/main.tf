# -------------------------------------------------------------------------------------
# VIRTUAL PRIVATE CLOUD (VPC)
# 
# This module will create a VPC that can be used for application deployments.
#
# The module creates a VPC with both public and private subnets. For production
# deployments, at least three availability zones (AZs) should be used. For non-
# production deployments one subnet should suffice. For cost savings using one 
# NAT gateway will work. For highly-available workloads, one NAT should be used
# per AZ.
#
# The module includes the following:
#
# - VPC
# - Internet Gateway
# - NAT Gateway
# - Public Subnets
# - Public Subnets' Route Table
# - Public Subnets' NACL
# - Private Subnets
# - Private Subnets' Route Table
# - Private Subnets' NACL
#
# -------------------------------------------------------------------------------------


# -------------------------------------------
# SET TERRAFORM REQUIREMENTS TO RUN MODULE
# -------------------------------------------

terraform {
  required_version = ">= 1.5.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}


# -------------------------------------------
# RETRIEVE REGION INFORMATION
# -------------------------------------------

data "aws_region" "current" {}

data "aws_availability_zones" "current" {
  filter {
    name   = "region-name"
    values = [data.aws_region.current.name]
  }

  filter {
    name   = "zone-type"
    values = ["availability-zone"]
  }

  lifecycle {
    # If the number of availability zones requested is greater than the number
    # of availability zones in the region, then the module should fail.
    postcondition {
      condition     = try(length(self.names) >= var.num_availability_zones, true)
      error_message = "The number of availability zones requested is greater than the number of availability zones in the region."
    }
  }

  timeouts {
    read = "20m"
  }
}


# ------------------------------------------------------------

# THE FOLLOWING SECTION IS USED TO CREATE THE VPC,

# INTERNET GATEWAY (IGW), AND NAT GATEWAY

# ------------------------------------------------------------

locals {
  num_availability_zones = var.num_availability_zones == null ? length(data.aws_availability_zones.current.names) : var.num_availability_zones

  # Gets a subset of the availability zones based on the number
  # of availability zones requested.
  availability_zones = slice(data.aws_availability_zones.current.names, 0, local.num_availability_zones)

  create_nat_gateway = var.create_nat_gateway && var.create_public_subnets && var.create_private_subnets
}


# --------------------------------------------------------------------
# CREATE THE VPC
# --------------------------------------------------------------------

# tfsec:ignore:aws-ec2-require-vpc-flow-logs-for-all-vpcs
resource "aws_vpc" "this" {
  cidr_block = "10.0.0.0/18"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = var.vpc_name
  }
}


# --------------------------------------------------------------------
# CREATE THE INTERNET GATEWAY
# --------------------------------------------------------------------

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-igw"
  }
}


# --------------------------------------------------------------------
# CREATE THE NAT GATEWAY
# --------------------------------------------------------------------

resource "aws_eip" "nat" {
  count = local.create_nat_gateway ? 1 : 0

  domain = "vpc"

  tags = {
    Name = format(
      "${var.vpc_name}-eip-%s",
      element(local.availability_zones, count.index)
    )
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}

# The Nat Gateway is deployed in a public subnet for a private subnet to use
# the public subnets must be created first.
resource "aws_nat_gateway" "this" {
  count = local.create_nat_gateway ? 1 : 0

  allocation_id = aws_eip.nat[0].id

  # If multiple NAT gateway support is added
  # as a feature, this will need to compute which
  # subnet to deploy the NAT gateway into.
  subnet_id = aws_subnet.public[0].id

  tags = {
    # If multiple NAT gateway support is added
    # as a feature, this will need to be updated.
    Name = "${var.vpc_name}-nat"
  }

  depends_on = [
    aws_internet_gateway.this
  ]
}


# ------------------------------------------------------------

# THE FOLLOWING SECTION IS USED TO CREATE THE

# PUBLIC AND PRIVATE SUBNETS, AS WELL AS THE

# ROUTE TABLES AND NACL FOR EACH SUBNET

# ------------------------------------------------------------


# --------------------------------------------------------------------
# CONVENIENCE LOCALS TO USE THROUGHOUT THE SECTION
# --------------------------------------------------------------------

locals {
  num_public_subnets  = var.create_public_subnets ? length(local.availability_zones) : 0
  num_private_subnets = var.create_private_subnets ? length(local.availability_zones) : 0
}


# --------------------------------------------------------------------
# CREATE THE PUBLIC SUBNETS
# --------------------------------------------------------------------

resource "aws_subnet" "public" {
  # Create a subnet for the number of availability zones
  # requested, otherwise create a subnet for each availability
  # zone in the region.
  count = local.num_public_subnets

  availability_zone = element(local.availability_zones, count.index)
  cidr_block        = cidrsubnet(aws_vpc.this.cidr_block, 6, count.index + 1)

  vpc_id = aws_vpc.this.id

  tags = {
    Name = format(
      "${var.vpc_name}-public-%s",
      element(local.availability_zones, count.index)
    )
  }
}


# --------------------------------------------------------------------
# CREATE THE PUBLIC ROUTE TABLES
# --------------------------------------------------------------------

resource "aws_route_table" "public" {
  count = var.create_public_subnets ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-public-rt"
  }
}

resource "aws_route" "public_igw" {
  count = var.create_public_subnets ? 1 : 0

  route_table_id = aws_route_table.public[0].id

  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "public" {
  count = var.create_public_subnets ? local.num_public_subnets : 0

  route_table_id = aws_route_table.public[0].id
  subnet_id      = aws_subnet.public[count.index].id
}


# --------------------------------------------------------------------
# CREATE THE PUBLIC NACL
# --------------------------------------------------------------------

# Condition: The public NACL should use the default option

resource "aws_network_acl" "public" {
  count = var.create_public_subnets ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.public[*].id

  tags = {
    Name = "${var.vpc_name}-public-acl"
  }
}

# tfsec:ignore:aws-ec2-no-public-ingress-acl
resource "aws_network_acl_rule" "public_ingress" {
  count = var.create_public_subnets ? 1 : 0

  network_acl_id = aws_network_acl.public[0].id
  egress         = false

  protocol    = -1
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
}

resource "aws_network_acl_rule" "public_egress" {
  count = var.create_public_subnets ? 1 : 0

  network_acl_id = aws_network_acl.public[0].id
  egress         = true

  protocol    = -1
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
}


# --------------------------------------------------------------------
# CREATE THE PRIVATE SUBNETS
# --------------------------------------------------------------------

resource "aws_subnet" "private" {
  count = local.num_private_subnets

  availability_zone = element(local.availability_zones, count.index)

  # Adds the number of public subnets to the count.index
  # to netnums to avoid overlapping with the public subnets.
  cidr_block = cidrsubnet(aws_vpc.this.cidr_block, 6, count.index + 1 + local.num_public_subnets)

  vpc_id = aws_vpc.this.id

  tags = {
    Name = format(
      "${var.vpc_name}-private-%s",
      element(local.availability_zones, count.index)
    )
  }
}


# --------------------------------------------------------------------
# CREATE THE PRIVATE ROUTE TABLES
# --------------------------------------------------------------------

resource "aws_route_table" "private" {
  count = var.create_private_subnets ? 1 : 0

  vpc_id = aws_vpc.this.id

  tags = {
    Name = "${var.vpc_name}-private-rt"
  }
}

resource "aws_route" "private_nat" {
  count = var.create_private_subnets && local.create_nat_gateway ? 1 : 0

  route_table_id = aws_route_table.private[0].id

  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this[0].id

  timeouts {
    create = "5m"
  }
}

resource "aws_route_table_association" "private" {
  count = var.create_private_subnets && local.create_nat_gateway ? local.num_private_subnets : 0

  route_table_id = aws_route_table.private[0].id
  subnet_id      = aws_subnet.private[count.index].id
}


# --------------------------------------------------------------------
# CREATE THE PRIVATE NACL
# --------------------------------------------------------------------

resource "aws_network_acl" "private" {
  count = var.create_private_subnets ? 1 : 0

  vpc_id     = aws_vpc.this.id
  subnet_ids = aws_subnet.private[*].id

  tags = {
    Name = "${var.vpc_name}-private-acl"
  }
}

# tfsec:ignore:aws-ec2-no-public-ingress-acl
resource "aws_network_acl_rule" "private_ingress" {
  count = var.create_private_subnets ? 1 : 0

  network_acl_id = aws_network_acl.private[0].id
  egress         = false

  protocol    = -1
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
}

resource "aws_network_acl_rule" "private_egress" {
  count = var.create_private_subnets ? 1 : 0

  network_acl_id = aws_network_acl.private[0].id
  egress         = true

  protocol    = -1
  rule_number = 100
  rule_action = "allow"
  cidr_block  = "0.0.0.0/0"
  from_port   = 0
  to_port     = 0
}
