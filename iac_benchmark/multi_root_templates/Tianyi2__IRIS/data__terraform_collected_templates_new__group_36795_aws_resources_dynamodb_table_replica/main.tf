resource "aws_dynamodb_table_replica" "this" {
  global_table_arn            = var.global_table_arn
  region                      = var.region
  kms_key_arn                 = var.kms_key_arn
  deletion_protection_enabled = var.deletion_protection_enabled
  point_in_time_recovery      = var.point_in_time_recovery
  table_class_override        = var.table_class_override
  tags                        = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
      delete = timeouts.value.delete
    }
  }
}