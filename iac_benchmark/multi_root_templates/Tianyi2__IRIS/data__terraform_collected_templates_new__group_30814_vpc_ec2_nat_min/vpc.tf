resource "aws_vpc" "this" {
  cidr_block           = local.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = { Name = "${local.name}-vpc" }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${local.name}-public" }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${local.name}-private" }
}

resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id
  tags   = { Name = "${local.name}-igw" }
}

resource "aws_route" "public_internet" {
  // Allow public subnet connect to internet
  route_table_id         = aws_route_table.public.id
  gateway_id             = aws_internet_gateway.this.id
  destination_cidr_block = "0.0.0.0/0"
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.this.id
  cidr_block              = local.public_subnet
  availability_zone       = local.subnet_availability_zone
  map_public_ip_on_launch = true
  tags                    = { Name = "${local.name}-public-${local.subnet_availability_zone}" }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = local.private_subnet
  availability_zone = local.subnet_availability_zone
  tags              = { Name = "${local.name}-private-${local.subnet_availability_zone}" }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}
