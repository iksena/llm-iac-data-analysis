resource "aws_ec2_client_vpn_authorization_rule" "this" {
  client_vpn_endpoint_id = var.client_vpn_endpoint_id
  target_network_cidr    = var.target_network_cidr
  access_group_id        = var.access_group_id
  authorize_all_groups   = var.authorize_all_groups
  description            = var.description

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}