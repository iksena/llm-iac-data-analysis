resource "aws_networkmanager_customer_gateway_association" "this" {
  customer_gateway_arn = var.customer_gateway_arn
  device_id            = var.device_id
  global_network_id    = var.global_network_id
  link_id              = var.link_id

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}