resource "aws_networkmanager_site_to_site_vpn_attachment" "this" {
  core_network_id    = var.core_network_id
  vpn_connection_arn = var.vpn_connection_arn

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}