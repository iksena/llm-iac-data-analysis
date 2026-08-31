data "aws_availability_zones" "all" {}

resource "aws_subnet" "public" {
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 1 + count.index)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.all.names[count.index]
  count                   = var.az_count
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.solution_short}-${var.env}-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, 10 + count.index)
  vpc_id                  = aws_vpc.vpc.id
  availability_zone       = data.aws_availability_zones.all.names[count.index]
  count                   = var.az_count
  map_public_ip_on_launch = false

  tags = {
    Name = "${var.solution_short}-${var.env}-private-subnet-${count.index}"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  count  = var.az_count

  tags = {
    Name = "${var.solution_short}-${var.env}-private-rtbl-${count.index}"
  }
}

resource "aws_route_table_association" "private" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = element(aws_route_table.private.*.id, count.index)
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.solution_short}-${var.env}-public-rtbl"
  }
}

resource "aws_route_table_association" "public" {
  count          = var.az_count
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}
