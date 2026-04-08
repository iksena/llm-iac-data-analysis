resource "aws_ec2_client_vpn_route" "this" {
  client_vpn_endpoint_id = var.client_vpn_endpoint_id
  destination_cidr_block = var.destination_cidr_block
  target_vpc_subnet_id   = var.target_vpc_subnet_id

  description = var.description

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}