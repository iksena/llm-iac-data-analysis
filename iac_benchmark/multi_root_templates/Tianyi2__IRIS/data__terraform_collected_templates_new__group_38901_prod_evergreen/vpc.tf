resource "aws_vpc" "evergreen" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "evergreen-prod-vpc"
  }
}

locals {
  public_subnets     = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
  private_subnets    = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24"]
  availability_zones = ["eu-north-1a", "eu-north-1b", "eu-north-1c"]
}

## ---------------------------------------------------------------------------------------------------------------------
## Configuration for the public subnets in the VPC.
##
## The public subnets are accessible from the internet and should be used by anything that needs to be publicly
## accessible. This includes things like NAT gateways, load balancers, and so on.
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "public" {
  count             = length(local.public_subnets)
  vpc_id            = aws_vpc.evergreen.id
  cidr_block        = element(local.public_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = "evergreen-prod-public-${element(local.availability_zones, count.index)}"
  }
}

resource "aws_internet_gateway" "public" {
  vpc_id = aws_vpc.evergreen.id

  tags = {
    Name = "evergreen-prod-public"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.evergreen.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.public.id
  }

  tags = {
    Name = "evergreen-prod-public"
  }
}

resource "aws_route_table_association" "public" {
  count          = length(local.public_subnets)
  subnet_id      = element(aws_subnet.public[*].id, count.index)
  route_table_id = aws_route_table.public.id
}

## ---------------------------------------------------------------------------------------------------------------------
## Configuration for the private subnets in the VPC.
##
## The private subnets are not accessible from the internet. This means services like instances, databases, and other
## private infrastructure should be deployed here.
##
## The private subnets can reach the public internet through a NAT gateway. We don't like to pay for AWS NAT Gateway,
## so we deploy a fck-nat instance instead.
## ---------------------------------------------------------------------------------------------------------------------

resource "aws_subnet" "private" {
  count             = length(local.private_subnets)
  vpc_id            = aws_vpc.evergreen.id
  cidr_block        = element(local.private_subnets, count.index)
  availability_zone = element(local.availability_zones, count.index)

  tags = {
    Name = "evergreen-prod-private-${element(local.availability_zones, count.index)}"
  }
}

resource "aws_network_interface" "nat" {
  subnet_id       = aws_subnet.public[0].id
  security_groups = [aws_security_group.nat.id]

  source_dest_check = false

  tags = {
    Name = "evergreen-prod-nat"
  }
}

resource "aws_eip" "nat" {
  domain = "vpc"

  tags = {
    Name = "evergreen-prod-nat"
  }
}

resource "aws_eip_association" "nat" {
  instance_id   = aws_instance.nat_gateway.id
  allocation_id = aws_eip.nat.id
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.evergreen.id

  route {
    cidr_block           = "0.0.0.0/0"
    network_interface_id = aws_network_interface.nat.id
  }

  tags = {
    Name = "evergreen-prod-private"
  }
}

resource "aws_route_table_association" "private" {
  count          = length(local.private_subnets)
  subnet_id      = element(aws_subnet.private[*].id, count.index)
  route_table_id = aws_route_table.private.id
}
