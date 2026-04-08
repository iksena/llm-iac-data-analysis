resource "aws_fsx_windows_file_system" "this" {
  subnet_ids          = var.subnet_ids
  throughput_capacity = var.throughput_capacity

  region                            = var.region
  active_directory_id               = var.active_directory_id
  aliases                           = var.aliases
  automatic_backup_retention_days   = var.automatic_backup_retention_days
  backup_id                         = var.backup_id
  copy_tags_to_backups              = var.copy_tags_to_backups
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  deployment_type                   = var.deployment_type
  final_backup_tags                 = var.final_backup_tags
  kms_key_id                        = var.kms_key_id
  preferred_subnet_id               = var.preferred_subnet_id
  security_group_ids                = var.security_group_ids
  skip_final_backup                 = var.skip_final_backup
  tags                              = var.tags
  storage_capacity                  = var.storage_capacity
  storage_type                      = var.storage_type
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time

  dynamic "audit_log_configuration" {
    for_each = var.audit_log_configuration != null ? [var.audit_log_configuration] : []
    content {
      audit_log_destination             = audit_log_configuration.value.audit_log_destination
      file_access_audit_log_level       = audit_log_configuration.value.file_access_audit_log_level
      file_share_access_audit_log_level = audit_log_configuration.value.file_share_access_audit_log_level
    }
  }

  dynamic "disk_iops_configuration" {
    for_each = var.disk_iops_configuration != null ? [var.disk_iops_configuration] : []
    content {
      iops = disk_iops_configuration.value.iops
      mode = disk_iops_configuration.value.mode
    }
  }

  dynamic "self_managed_active_directory" {
    for_each = var.self_managed_active_directory != null ? [var.self_managed_active_directory] : []
    content {
      dns_ips                                = self_managed_active_directory.value.dns_ips
      domain_name                            = self_managed_active_directory.value.domain_name
      password                               = self_managed_active_directory.value.password
      username                               = self_managed_active_directory.value.username
      file_system_administrators_group       = self_managed_active_directory.value.file_system_administrators_group
      organizational_unit_distinguished_name = self_managed_active_directory.value.organizational_unit_distinguished_name
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}