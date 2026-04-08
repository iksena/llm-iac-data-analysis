resource "aws_m2_environment" "this" {
  name                         = var.name
  engine_type                  = var.engine_type
  instance_type                = var.instance_type
  region                       = var.region
  engine_version               = var.engine_version
  force_update                 = var.force_update
  kms_key_id                   = var.kms_key_id
  preferred_maintenance_window = var.preferred_maintenance_window
  publicly_accessible          = var.publicly_accessible
  security_group_ids           = var.security_group_ids
  subnet_ids                   = var.subnet_ids
  tags                         = var.tags

  dynamic "storage_configuration" {
    for_each = var.storage_configuration != null ? [var.storage_configuration] : []
    content {
      dynamic "efs" {
        for_each = storage_configuration.value.efs != null ? [storage_configuration.value.efs] : []
        content {
          mount_point    = efs.value.mount_point
          file_system_id = efs.value.file_system_id
        }
      }

      dynamic "fsx" {
        for_each = storage_configuration.value.fsx != null ? [storage_configuration.value.fsx] : []
        content {
          mount_point    = fsx.value.mount_point
          file_system_id = fsx.value.file_system_id
        }
      }
    }
  }

  dynamic "high_availability_config" {
    for_each = var.high_availability_config != null ? [var.high_availability_config] : []
    content {
      desired_capacity = high_availability_config.value.desired_capacity
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}