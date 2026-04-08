resource "aws_rds_cluster_snapshot_copy" "this" {
  source_db_cluster_snapshot_identifier = var.source_db_cluster_snapshot_identifier
  target_db_cluster_snapshot_identifier = var.target_db_cluster_snapshot_identifier

  region             = var.region
  copy_tags          = var.copy_tags
  destination_region = var.destination_region
  kms_key_id         = var.kms_key_id
  presigned_url      = var.presigned_url
  shared_accounts    = var.shared_accounts
  tags               = var.tags

  dynamic "timeouts" {
    for_each = length(keys(var.timeouts)) > 0 ? [var.timeouts] : []
    content {
      create = timeouts.value.create
    }
  }
}