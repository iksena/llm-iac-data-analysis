resource "aws_network_interface_permission" "this" {
  region               = var.region
  network_interface_id = var.network_interface_id
  aws_account_id       = var.aws_account_id
  permission           = var.permission
}