resource "aws_db_instance_automated_backups_replication" "this" {
  source_db_instance_arn = var.source_db_instance_arn
  region                 = var.region
  kms_key_id             = var.kms_key_id
  pre_signed_url         = var.pre_signed_url
  retention_period       = var.retention_period

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}