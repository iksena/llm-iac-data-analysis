resource "aws_dms_replication_config" "this" {
  region                        = var.region
  replication_config_identifier = var.replication_config_identifier
  replication_type              = var.replication_type
  source_endpoint_arn           = var.source_endpoint_arn
  table_mappings                = var.table_mappings
  target_endpoint_arn           = var.target_endpoint_arn
  start_replication             = var.start_replication
  replication_settings          = var.replication_settings
  resource_identifier           = var.resource_identifier
  supplemental_settings         = var.supplemental_settings
  tags                          = var.tags

  compute_config {
    availability_zone            = var.compute_config.availability_zone
    dns_name_servers             = var.compute_config.dns_name_servers != null ? join(",", var.compute_config.dns_name_servers) : null
    kms_key_id                   = var.compute_config.kms_key_id
    max_capacity_units           = var.compute_config.max_capacity_units
    min_capacity_units           = var.compute_config.min_capacity_units
    multi_az                     = var.compute_config.multi_az
    preferred_maintenance_window = var.compute_config.preferred_maintenance_window
    replication_subnet_group_id  = var.compute_config.replication_subnet_group_id
    vpc_security_group_ids       = var.compute_config.vpc_security_group_ids
  }

  timeouts {
    create = "60m"
    update = "60m"
    delete = "60m"
  }
}