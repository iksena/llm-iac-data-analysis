resource "aws_networkmanager_device" "this" {
  global_network_id = var.global_network_id
  site_id           = var.site_id
  description       = var.description
  model             = var.model
  serial_number     = var.serial_number
  type              = var.type
  vendor            = var.vendor
  tags              = var.tags

  dynamic "aws_location" {
    for_each = var.aws_location != null ? [var.aws_location] : []
    content {
      subnet_arn = aws_location.value.subnet_arn
      zone       = aws_location.value.zone
    }
  }

  dynamic "location" {
    for_each = var.location != null ? [var.location] : []
    content {
      address   = location.value.address
      latitude  = location.value.latitude
      longitude = location.value.longitude
    }
  }

  timeouts {
    create = var.timeout_create
    update = var.timeout_update
    delete = var.timeout_delete
  }
}