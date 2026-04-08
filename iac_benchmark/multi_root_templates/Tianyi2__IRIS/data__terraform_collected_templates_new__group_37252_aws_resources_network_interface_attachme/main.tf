resource "aws_network_interface_attachment" "this" {
  region               = var.region
  instance_id          = var.instance_id
  network_interface_id = var.network_interface_id
  device_index         = var.device_index
  network_card_index   = var.network_card_index
}