resource "aws_elasticache_replication_group" "this" {
  description          = var.description
  replication_group_id = var.replication_group_id

  region                      = var.region
  apply_immediately           = var.apply_immediately
  at_rest_encryption_enabled  = var.at_rest_encryption_enabled
  auth_token                  = var.auth_token
  auth_token_update_strategy  = var.auth_token_update_strategy
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  automatic_failover_enabled  = var.automatic_failover_enabled
  cluster_mode                = var.cluster_mode
  data_tiering_enabled        = var.data_tiering_enabled
  engine                      = var.engine
  engine_version              = var.engine_version
  final_snapshot_identifier   = var.final_snapshot_identifier
  global_replication_group_id = var.global_replication_group_id
  ip_discovery                = var.ip_discovery
  kms_key_id                  = var.kms_key_id
  maintenance_window          = var.maintenance_window
  multi_az_enabled            = var.multi_az_enabled
  network_type                = var.network_type
  node_type                   = var.node_type
  notification_topic_arn      = var.notification_topic_arn
  num_cache_clusters          = var.num_cache_clusters
  num_node_groups             = var.num_node_groups
  parameter_group_name        = var.parameter_group_name
  port                        = var.port
  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
  replicas_per_node_group     = var.replicas_per_node_group
  security_group_ids          = var.security_group_ids
  security_group_names        = var.security_group_names
  snapshot_arns               = var.snapshot_arns
  snapshot_name               = var.snapshot_name
  snapshot_retention_limit    = var.snapshot_retention_limit
  snapshot_window             = var.snapshot_window
  subnet_group_name           = var.subnet_group_name
  tags                        = var.tags
  transit_encryption_enabled  = var.transit_encryption_enabled
  transit_encryption_mode     = var.transit_encryption_mode
  user_group_ids              = var.user_group_ids

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
    update = var.timeouts.update
  }
}