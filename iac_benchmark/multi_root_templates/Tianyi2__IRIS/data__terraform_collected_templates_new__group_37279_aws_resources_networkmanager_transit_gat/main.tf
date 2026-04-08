resource "aws_networkmanager_transit_gateway_registration" "this" {
  global_network_id   = var.global_network_id
  transit_gateway_arn = var.transit_gateway_arn

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}