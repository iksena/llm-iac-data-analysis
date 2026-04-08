resource "aws_fsx_openzfs_volume" "this" {
  region                           = var.region
  name                             = var.name
  parent_volume_id                 = var.parent_volume_id
  copy_tags_to_snapshots           = var.copy_tags_to_snapshots
  data_compression_type            = var.data_compression_type
  delete_volume_options            = var.delete_volume_options
  read_only                        = var.read_only
  record_size_kib                  = var.record_size_kib
  storage_capacity_quota_gib       = var.storage_capacity_quota_gib
  storage_capacity_reservation_gib = var.storage_capacity_reservation_gib
  tags                             = var.tags

  dynamic "nfs_exports" {
    for_each = var.nfs_exports != null ? [var.nfs_exports] : []
    content {
      dynamic "client_configurations" {
        for_each = nfs_exports.value.client_configurations
        content {
          clients = client_configurations.value.clients
          options = client_configurations.value.options
        }
      }
    }
  }

  dynamic "origin_snapshot" {
    for_each = var.origin_snapshot != null ? [var.origin_snapshot] : []
    content {
      copy_strategy = origin_snapshot.value.copy_strategy
      snapshot_arn  = origin_snapshot.value.snapshot_arn
    }
  }

  dynamic "user_and_group_quotas" {
    for_each = var.user_and_group_quotas != null ? var.user_and_group_quotas : []
    content {
      id                         = user_and_group_quotas.value.id
      storage_capacity_quota_gib = user_and_group_quotas.value.storage_capacity_quota_gib
      type                       = user_and_group_quotas.value.Type
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}