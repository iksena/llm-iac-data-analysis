resource "aws_nat_gateway" "ngw" {
  count = var.subnet_private_cidrs == null ? 0 : length(var.subnet_public_cidrs)

  allocation_id = aws_eip.natgw[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    {
      "Name" = "${var.base_name}-nat-gateway-${count.index}"
    },
    var.tags
  )
}