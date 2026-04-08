resource "aws_vpclattice_service_network_vpc_association" "this" {
  vpc_identifier             = var.vpc_identifier
  service_network_identifier = var.service_network_identifier
  security_group_ids         = var.security_group_ids
  tags                       = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}