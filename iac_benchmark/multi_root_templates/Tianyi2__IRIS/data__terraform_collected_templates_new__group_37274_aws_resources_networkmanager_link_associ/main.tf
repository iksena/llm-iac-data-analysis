resource "aws_networkmanager_link_association" "this" {
  device_id         = var.device_id
  global_network_id = var.global_network_id
  link_id           = var.link_id

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}