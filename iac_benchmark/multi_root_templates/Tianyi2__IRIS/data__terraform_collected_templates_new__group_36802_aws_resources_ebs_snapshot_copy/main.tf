resource "aws_ebs_snapshot_copy" "this" {
  source_snapshot_id          = var.source_snapshot_id
  source_region               = var.source_region
  region                      = var.region
  description                 = var.description
  encrypted                   = var.encrypted
  kms_key_id                  = var.kms_key_id
  storage_tier                = var.storage_tier
  permanent_restore           = var.permanent_restore
  temporary_restore_days      = var.temporary_restore_days
  completion_duration_minutes = var.completion_duration_minutes
  tags                        = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}