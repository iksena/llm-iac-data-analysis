// Only with has_nat_gateway = true
// Elastic IPs
resource "aws_eip" "nat_ig_elastic_ip" {
  domain   = "vpc"
  count = "${var.has_nat_gateway?2:0}"
  tags = merge ({
    Name = "${var.name}_route_table_elastic_ip_${count.index==0?"a":"b"}"
  },var.tags)
}

// Nat Gateways
resource "aws_nat_gateway" "nat_gateway_public_a" {
  allocation_id = "${aws_eip.nat_ig_elastic_ip[0].id}"
  subnet_id = "${aws_subnet.public_a.id}"
  count = "${var.has_nat_gateway?1:0}"
  tags = merge ({
    Name = "${var.name}_nat_gateway_a"
  },var.tags)
}

resource "aws_nat_gateway" "nat_gateway_public_b" {
  allocation_id = "${aws_eip.nat_ig_elastic_ip[1].id}"
  subnet_id = "${aws_subnet.public_b.id}"
  count = "${var.has_nat_gateway?1:0}"
  tags = merge ({
    Name = "${var.name}_nat_gateway_b"
  },var.tags)
}

// Route Tables
resource "aws_route_table" "nat_gateway_private_table_a" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gateway_public_a[0].id}"
    }
  tags = merge ({
    Name = "${var.name}_private_table_a"
    type = "private"
  },var.tags)
  count = "${var.has_nat_gateway?1:0}"
}

resource "aws_route_table" "nat_gateway_private_table_b" {
  vpc_id = "${aws_vpc.main.id}"
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.nat_gateway_public_b[0].id}"
    }
  tags = merge ({
    Name = "${var.name}_private_table_b"
    type = "private"
  },var.tags)
  count = "${var.has_nat_gateway?1:0}"
}

// Association

resource "aws_route_table_association" "nat_gateway_route_route_a" {
  subnet_id      = aws_subnet.private_a[0].id
  route_table_id = aws_route_table.nat_gateway_private_table_a[0].id
  count = "${var.has_nat_gateway?1:0}"
}

resource "aws_route_table_association" "nat_gateway_route_route_b" {
  subnet_id      = aws_subnet.private_b[0].id
  route_table_id = aws_route_table.nat_gateway_private_table_b[0].id
  count = "${var.has_nat_gateway?1:0}"
}
