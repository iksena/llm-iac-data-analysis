locals {
  # Validate that both cdc_start_position and cdc_start_time are not set
  validate_cdc_conflict = var.cdc_start_position != null && var.cdc_start_time != null ? tobool("ERROR: cdc_start_position conflicts with cdc_start_time. Only one can be specified.") : true
}

resource "aws_dms_replication_task" "this" {
  region                    = var.region
  cdc_start_position        = var.cdc_start_position
  cdc_start_time            = var.cdc_start_time
  migration_type            = var.migration_type
  replication_instance_arn  = var.replication_instance_arn
  replication_task_id       = var.replication_task_id
  replication_task_settings = var.replication_task_settings
  resource_identifier       = var.resource_identifier
  source_endpoint_arn       = var.source_endpoint_arn
  start_replication_task    = var.start_replication_task
  table_mappings            = var.table_mappings
  tags                      = var.tags
  target_endpoint_arn       = var.target_endpoint_arn

  depends_on = [local.validate_cdc_conflict]
}