resource "aws_networkmanager_site" "this" {
  global_network_id = var.global_network_id
  description       = var.description
  tags              = var.tags

  dynamic "location" {
    for_each = var.location != null ? [var.location] : []
    content {
      address   = location.value.address
      latitude  = location.value.latitude
      longitude = location.value.longitude
    }
  }
}