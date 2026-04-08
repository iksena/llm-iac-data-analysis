resource "aws_finspace_kx_volume" "this" {
  name               = var.name
  environment_id     = var.environment_id
  availability_zones = var.availability_zones
  az_mode            = var.az_mode
  type               = var.type

  description = var.description
  region      = var.region
  tags        = var.tags

  dynamic "nas1_configuration" {
    for_each = var.nas1_configuration != null ? [var.nas1_configuration] : []
    content {
      size = nas1_configuration.value.size
      type = nas1_configuration.value.type
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}