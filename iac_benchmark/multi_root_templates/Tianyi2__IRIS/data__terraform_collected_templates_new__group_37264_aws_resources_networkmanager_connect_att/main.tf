resource "aws_networkmanager_connect_attachment" "this" {
  core_network_id         = var.core_network_id
  edge_location           = var.edge_location
  transport_attachment_id = var.transport_attachment_id
  tags                    = var.tags

  options {
    protocol = var.options.protocol
  }

  timeouts {
    create = "10m"
    delete = "10m"
  }
}