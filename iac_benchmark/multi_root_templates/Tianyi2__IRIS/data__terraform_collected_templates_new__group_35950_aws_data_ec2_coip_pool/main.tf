data "aws_ec2_coip_pool" "this" {
  region                       = var.region
  local_gateway_route_table_id = var.local_gateway_route_table_id
  pool_id                      = var.pool_id
  tags                         = var.tags

  dynamic "filter" {
    for_each = var.filter
    content {
      name   = filter.value.name
      values = filter.value.values
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      read = timeouts.value.read
    }
  }
}