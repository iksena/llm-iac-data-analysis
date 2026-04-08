resource "aws_neptune_cluster" "this" {
  allow_major_version_upgrade           = var.allow_major_version_upgrade
  apply_immediately                     = var.apply_immediately
  availability_zones                    = var.availability_zones
  backup_retention_period               = var.backup_retention_period
  cluster_identifier                    = var.cluster_identifier
  cluster_identifier_prefix             = var.cluster_identifier_prefix
  copy_tags_to_snapshot                 = var.copy_tags_to_snapshot
  deletion_protection                   = var.deletion_protection
  enable_cloudwatch_logs_exports        = var.enable_cloudwatch_logs_exports
  engine                                = var.engine
  engine_version                        = var.engine_version
  final_snapshot_identifier             = var.final_snapshot_identifier
  global_cluster_identifier             = var.global_cluster_identifier
  iam_roles                             = var.iam_roles
  iam_database_authentication_enabled   = var.iam_database_authentication_enabled
  kms_key_arn                           = var.kms_key_arn
  neptune_cluster_parameter_group_name  = var.neptune_cluster_parameter_group_name
  neptune_instance_parameter_group_name = var.neptune_instance_parameter_group_name
  neptune_subnet_group_name             = var.neptune_subnet_group_name
  port                                  = var.port
  preferred_backup_window               = var.preferred_backup_window
  preferred_maintenance_window          = var.preferred_maintenance_window
  region                                = var.region
  replication_source_identifier         = var.replication_source_identifier
  skip_final_snapshot                   = var.skip_final_snapshot
  snapshot_identifier                   = var.snapshot_identifier
  storage_encrypted                     = var.storage_encrypted
  storage_type                          = var.storage_type
  tags                                  = var.tags
  vpc_security_group_ids                = var.vpc_security_group_ids

  dynamic "serverless_v2_scaling_configuration" {
    for_each = var.serverless_v2_scaling_configuration != null ? [var.serverless_v2_scaling_configuration] : []
    content {
      min_capacity = serverless_v2_scaling_configuration.value.min_capacity
      max_capacity = serverless_v2_scaling_configuration.value.max_capacity
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}