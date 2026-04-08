resource "aws_networkmanager_connection" "this" {
  global_network_id   = var.global_network_id
  device_id           = var.device_id
  connected_device_id = var.connected_device_id
  connected_link_id   = var.connected_link_id
  description         = var.description
  link_id             = var.link_id
  tags                = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}