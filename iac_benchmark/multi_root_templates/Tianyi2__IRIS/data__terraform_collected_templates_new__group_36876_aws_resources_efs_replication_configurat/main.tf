resource "aws_efs_replication_configuration" "this" {
  source_file_system_id = var.source_file_system_id

  dynamic "destination" {
    for_each = [var.destination]
    content {
      availability_zone_name = destination.value.availability_zone_name
      file_system_id         = destination.value.file_system_id
      kms_key_id             = destination.value.kms_key_id
      region                 = destination.value.region
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}