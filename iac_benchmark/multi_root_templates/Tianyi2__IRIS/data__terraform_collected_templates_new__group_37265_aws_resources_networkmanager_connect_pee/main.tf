resource "aws_networkmanager_connect_peer" "this" {
  connect_attachment_id = var.connect_attachment_id
  peer_address          = var.peer_address

  dynamic "bgp_options" {
    for_each = var.bgp_options != null ? [var.bgp_options] : []
    content {
      peer_asn = bgp_options.value.peer_asn
    }
  }

  core_network_address = var.core_network_address
  inside_cidr_blocks   = var.inside_cidr_blocks
  subnet_arn           = var.subnet_arn
  tags                 = var.tags

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}