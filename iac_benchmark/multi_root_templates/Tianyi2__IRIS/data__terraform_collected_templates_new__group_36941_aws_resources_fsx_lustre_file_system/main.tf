resource "aws_fsx_lustre_file_system" "this" {
  region     = var.region
  subnet_ids = var.subnet_ids

  auto_import_policy                = var.auto_import_policy
  automatic_backup_retention_days   = var.automatic_backup_retention_days
  backup_id                         = var.backup_id
  copy_tags_to_backups              = var.copy_tags_to_backups
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  drive_cache_type                  = var.drive_cache_type
  data_compression_type             = var.data_compression_type
  deployment_type                   = var.deployment_type
  efa_enabled                       = var.efa_enabled
  export_path                       = var.export_path
  file_system_type_version          = var.file_system_type_version
  final_backup_tags                 = var.final_backup_tags
  imported_file_chunk_size          = var.imported_file_chunk_size
  import_path                       = var.import_path
  kms_key_id                        = var.kms_key_id
  per_unit_storage_throughput       = var.per_unit_storage_throughput
  security_group_ids                = var.security_group_ids
  skip_final_backup                 = var.skip_final_backup
  storage_capacity                  = var.storage_capacity
  storage_type                      = var.storage_type
  tags                              = var.tags
  throughput_capacity               = var.throughput_capacity
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time

  dynamic "log_configuration" {
    for_each = var.log_configuration != null ? [var.log_configuration] : []
    content {
      destination = log_configuration.value.destination
      level       = log_configuration.value.level
    }
  }

  dynamic "metadata_configuration" {
    for_each = var.metadata_configuration != null ? [var.metadata_configuration] : []
    content {
      iops = metadata_configuration.value.iops
      mode = metadata_configuration.value.mode
    }
  }

  dynamic "root_squash_configuration" {
    for_each = var.root_squash_configuration != null ? [var.root_squash_configuration] : []
    content {
      no_squash_nids = root_squash_configuration.value.no_squash_nids
      root_squash    = root_squash_configuration.value.root_squash
    }
  }

  dynamic "data_read_cache_configuration" {
    for_each = var.data_read_cache_configuration != null ? [var.data_read_cache_configuration] : []
    content {
      size        = data_read_cache_configuration.value.size
      sizing_mode = data_read_cache_configuration.value.sizing_mode
    }
  }

  timeouts {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}