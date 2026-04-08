resource "aws_fsx_ontap_file_system" "this" {
  region                            = var.region
  storage_capacity                  = var.storage_capacity
  subnet_ids                        = var.subnet_ids
  preferred_subnet_id               = var.preferred_subnet_id
  security_group_ids                = var.security_group_ids
  weekly_maintenance_start_time     = var.weekly_maintenance_start_time
  deployment_type                   = var.deployment_type
  kms_key_id                        = var.kms_key_id
  automatic_backup_retention_days   = var.automatic_backup_retention_days
  daily_automatic_backup_start_time = var.daily_automatic_backup_start_time
  endpoint_ip_address_range         = var.endpoint_ip_address_range
  ha_pairs                          = var.ha_pairs
  storage_type                      = var.storage_type
  fsx_admin_password                = var.fsx_admin_password
  route_table_ids                   = var.route_table_ids
  tags                              = var.tags
  throughput_capacity               = var.throughput_capacity
  throughput_capacity_per_ha_pair   = var.throughput_capacity_per_ha_pair

  dynamic "disk_iops_configuration" {
    for_each = var.disk_iops_configuration != null ? [var.disk_iops_configuration] : []
    content {
      iops = disk_iops_configuration.value.iops
      mode = disk_iops_configuration.value.mode
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}