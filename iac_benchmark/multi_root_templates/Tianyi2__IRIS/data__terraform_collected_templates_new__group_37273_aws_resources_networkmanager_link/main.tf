resource "aws_networkmanager_link" "this" {
  global_network_id = var.global_network_id
  site_id           = var.site_id

  dynamic "bandwidth" {
    for_each = var.bandwidth != null ? [var.bandwidth] : []
    content {
      download_speed = bandwidth.value.download_speed
      upload_speed   = bandwidth.value.upload_speed
    }
  }

  description   = var.description
  provider_name = var.provider_name
  tags          = var.tags
  type          = var.type

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}