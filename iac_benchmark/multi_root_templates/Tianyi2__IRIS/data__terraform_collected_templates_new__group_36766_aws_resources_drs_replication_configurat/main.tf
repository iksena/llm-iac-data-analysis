resource "aws_drs_replication_configuration_template" "this" {
  associate_default_security_group        = var.associate_default_security_group
  bandwidth_throttling                    = var.bandwidth_throttling
  create_public_ip                        = var.create_public_ip
  data_plane_routing                      = var.data_plane_routing
  default_large_staging_disk_type         = var.default_large_staging_disk_type
  ebs_encryption                          = var.ebs_encryption
  ebs_encryption_key_arn                  = var.ebs_encryption_key_arn
  replication_server_instance_type        = var.replication_server_instance_type
  replication_servers_security_groups_ids = var.replication_servers_security_groups_ids
  staging_area_subnet_id                  = var.staging_area_subnet_id
  staging_area_tags                       = var.staging_area_tags
  use_dedicated_replication_server        = var.use_dedicated_replication_server

  region                   = var.region
  auto_replicate_new_disks = var.auto_replicate_new_disks
  tags                     = var.tags

  dynamic "pit_policy" {
    for_each = var.pit_policy
    content {
      enabled            = pit_policy.value.enabled
      interval           = pit_policy.value.interval
      retention_duration = pit_policy.value.retention_duration
      rule_id            = pit_policy.value.rule_id
      units              = pit_policy.value.units
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}