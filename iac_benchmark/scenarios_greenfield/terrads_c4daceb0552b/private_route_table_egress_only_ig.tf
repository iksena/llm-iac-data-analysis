// Only with has_egress_only_internet_gateway = true
// Egress only internet gateway
resource "aws_egress_only_internet_gateway" "egress_only_ig" {
  vpc_id = "${aws_vpc.main.id}"
  count = "${var.has_egress_only_internet_gateway?1:0}"
}

// Route Tables
resource "aws_route_table" "private_egress_only_ig" {
  vpc_id = "${aws_vpc.main.id}"
  tags = merge ({
    Name = "${var.name}_private_route_table"
    type = "private"
  },var.tags)
  count = "${var.has_egress_only_internet_gateway?1:0}"
}

// Routes
resource "aws_route" "egress_only_ig_route" {
  route_table_id = "${aws_route_table.private_egress_only_ig[0].id}"
  destination_ipv6_cidr_block = "::/0"
  egress_only_gateway_id = "${aws_egress_only_internet_gateway.egress_only_ig[0].id}"
  count = "${var.has_egress_only_internet_gateway?1:0}"
}

// Association
resource "aws_route_table_association" "egress_only_ig_route_route_a" {
  subnet_id      = aws_subnet.private_a[0].id
  route_table_id = aws_route_table.private_egress_only_ig[0].id
  count = "${var.has_egress_only_internet_gateway?1:0}"
}

resource "aws_route_table_association" "egress_only_ig_route_route_b" {
  subnet_id      = aws_subnet.private_b[0].id
  route_table_id = aws_route_table.private_egress_only_ig[0].id
  count = "${var.has_egress_only_internet_gateway?1:0}"
}
