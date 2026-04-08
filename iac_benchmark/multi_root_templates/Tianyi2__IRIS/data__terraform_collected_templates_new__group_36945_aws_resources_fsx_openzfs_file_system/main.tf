resource "aws_fsx_openzfs_file_system" "this" {
  deployment_type     = var.deployment_type
  storage_capacity    = var.storage_capacity
  subnet_ids          = var.subnet_ids
  throughput_capacity = var.throughput_capacity

  region                            = var.region
  automatic_backup_retention_days   = var.automatic_backup_retention_days
  backup_id                         = var.backup_id
  copy_tags_to_backups              = var.copy_tags_to_backups
  copy_tags_to_volumes              = var.copy_tags_to_volumes
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  delete_options                    = var.delete_options
  endpoint_ip_address_range         = var.endpoint_ip_address_range
  final_backup_tags                 = var.final_backup_tags
  kms_key_id                        = var.kms_key_id
  preferred_subnet_id               = var.preferred_subnet_id
  route_table_ids                   = var.route_table_ids
  security_group_ids                = var.security_group_ids
  skip_final_backup                 = var.skip_final_backup
  storage_type                      = var.storage_type
  tags                              = var.tags
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time

  dynamic "user_and_group_quotas" {
    for_each = var.user_and_group_quotas != null ? var.user_and_group_quotas : []
    content {
      id                         = user_and_group_quotas.value.id
      storage_capacity_quota_gib = user_and_group_quotas.value.storage_capacity_quota_gib
      type                       = user_and_group_quotas.value.type
    }
  }

  dynamic "disk_iops_configuration" {
    for_each = var.disk_iops_configuration != null ? [var.disk_iops_configuration] : []
    content {
      iops = disk_iops_configuration.value.iops
      mode = disk_iops_configuration.value.mode
    }
  }

  dynamic "root_volume_configuration" {
    for_each = var.root_volume_configuration != null ? [var.root_volume_configuration] : []
    content {
      copy_tags_to_snapshots = root_volume_configuration.value.copy_tags_to_snapshots
      data_compression_type  = root_volume_configuration.value.data_compression_type
      read_only              = root_volume_configuration.value.read_only
      record_size_kib        = root_volume_configuration.value.record_size_kib

      dynamic "nfs_exports" {
        for_each = root_volume_configuration.value.nfs_exports != null ? [root_volume_configuration.value.nfs_exports] : []
        content {
          dynamic "client_configurations" {
            for_each = nfs_exports.value.client_configurations != null ? nfs_exports.value.client_configurations : []
            content {
              clients = client_configurations.value.clients
              options = client_configurations.value.options
            }
          }
        }
      }

      dynamic "user_and_group_quotas" {
        for_each = root_volume_configuration.value.user_and_group_quotas != null ? root_volume_configuration.value.user_and_group_quotas : []
        content {
          id                         = user_and_group_quotas.value.id
          storage_capacity_quota_gib = user_and_group_quotas.value.storage_capacity_quota_gib
          type                       = user_and_group_quotas.value.type
        }
      }
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}