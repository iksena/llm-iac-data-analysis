resource "aws_networkmanager_transit_gateway_route_table_attachment" "this" {
  peering_id                      = var.peering_id
  transit_gateway_route_table_arn = var.transit_gateway_route_table_arn
  tags                            = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = try(timeouts.value.create, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}