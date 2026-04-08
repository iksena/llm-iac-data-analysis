resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public.0.id

  tags = {
    Name = var.default_tag
  }
}

resource "aws_subnet" "private" {
  vpc_id                  = var.vpc_id
  count                   = length(split(",", var.availability_zones))
  cidr_block              = cidrsubnet(cidrsubnet(var.vpc_cidr, 2, 1), var.newbits, count.index)
  availability_zone       = element(split(",", var.availability_zones), count.index)
  map_public_ip_on_launch = false
  depends_on              = [aws_nat_gateway.gw]

  tags = {
    Name                                        = "${var.default_tag}-private-subnet",
    "kubernetes.io/cluster/${var.cluster_name}" = "shared",
    "kubernetes.io/role/internal-elb"           = "1"
  }
}

resource "aws_route_table" "private" {
  vpc_id = var.vpc_id

  tags = {
    Name = "${var.default_tag}-private-subnet"
  }
}

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.gw.id
}

resource "aws_route_table_association" "private" {
  count          = length(split(",", var.availability_zones))
  subnet_id      = element(aws_subnet.private.*.id, count.index)
  route_table_id = aws_route_table.private.id
}
