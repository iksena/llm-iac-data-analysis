resource "aws_route_table" "public_main" {
  vpc_id = "${aws_vpc.main.id}"
  // internet
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.main.id}"
  }
  tags = merge ({
    Name = "${var.name}_public_route_table"
    type = "public"
  },var.tags)
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public_main.id
}

resource "aws_route_table_association" "public_b" {
  subnet_id      = aws_subnet.public_b.id
  route_table_id = aws_route_table.public_main.id
}

// Optional
resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c[0].id
  route_table_id = aws_route_table.public_main.id
  count = "${!var.has_private_subnet ? 1 : 0}"

}

resource "aws_route_table_association" "public_d" {
  subnet_id      = aws_subnet.public_d[0].id
  route_table_id = aws_route_table.public_main.id
  count = "${!var.has_private_subnet ? 1 : 0}"
}
