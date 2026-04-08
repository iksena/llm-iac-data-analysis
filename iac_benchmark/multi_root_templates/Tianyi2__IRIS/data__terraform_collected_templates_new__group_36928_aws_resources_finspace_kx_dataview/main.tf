resource "aws_finspace_kx_dataview" "this" {
  name                 = var.name
  environment_id       = var.environment_id
  database_name        = var.database_name
  az_mode              = var.az_mode
  region               = var.region
  auto_update          = var.auto_update
  availability_zone_id = var.availability_zone_id
  changeset_id         = var.changeset_id
  description          = var.description
  read_write           = var.read_write
  tags                 = var.tags

  dynamic "segment_configurations" {
    for_each = var.segment_configurations
    content {
      db_paths    = segment_configurations.value.db_paths
      volume_name = segment_configurations.value.volume_name
      on_demand   = segment_configurations.value.on_demand
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}