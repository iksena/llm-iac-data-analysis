resource "aws_eip" "natgw" {
  count = var.subnet_private_cidrs == null ? 0 : length(var.subnet_public_cidrs)
  domain = "vpc"

  tags = merge(
    {
      "Name" = "${var.base_name}-natgw-eip-${count.index}"
    },
    var.tags
  )
}