resource "aws_networkfirewall_firewall_transit_gateway_attachment_accepter" "this" {
  region                        = var.region
  transit_gateway_attachment_id = var.transit_gateway_attachment_id

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}