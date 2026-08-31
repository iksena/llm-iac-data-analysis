resource "aws_eip" "nat" {
  vpc   = true
  count = var.az_count

  tags = {
    Name = "${var.solution_short}-${var.env}-eip-for-nat-gateway-${count.index}"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = element(aws_eip.nat.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id, count.index)
  count         = var.az_count

  tags = {
    Name = "${var.solution_short}-${var.env}-nat-gateway-${count.index}"
  }
}

resource "aws_route" "nat_gateway" {
  route_table_id         = element(aws_route_table.private.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = element(aws_nat_gateway.nat.*.id, count.index)
  count                  = var.az_count

  depends_on = [aws_route_table.private, aws_nat_gateway.nat]
}
