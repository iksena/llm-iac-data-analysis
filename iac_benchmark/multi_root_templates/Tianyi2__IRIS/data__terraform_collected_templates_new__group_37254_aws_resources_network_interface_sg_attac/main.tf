resource "aws_network_interface_sg_attachment" "this" {
  region               = var.region
  security_group_id    = var.security_group_id
  network_interface_id = var.network_interface_id

  timeouts {
    create = var.timeouts_create
    read   = var.timeouts_read
    delete = var.timeouts_delete
  }
}