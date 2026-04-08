resource "aws_elasticache_cluster" "this" {
  cluster_id                   = var.cluster_id
  engine                       = var.engine
  node_type                    = var.node_type
  num_cache_nodes              = var.num_cache_nodes
  parameter_group_name         = var.parameter_group_name
  region                       = var.region
  apply_immediately            = var.apply_immediately
  auto_minor_version_upgrade   = var.auto_minor_version_upgrade
  availability_zone            = var.availability_zone
  az_mode                      = var.az_mode
  engine_version               = var.engine_version
  final_snapshot_identifier    = var.final_snapshot_identifier
  ip_discovery                 = var.ip_discovery
  maintenance_window           = var.maintenance_window
  network_type                 = var.network_type
  notification_topic_arn       = var.notification_topic_arn
  outpost_mode                 = var.outpost_mode
  port                         = var.port
  preferred_availability_zones = var.preferred_availability_zones
  preferred_outpost_arn        = var.preferred_outpost_arn
  replication_group_id         = var.replication_group_id
  security_group_ids           = var.security_group_ids
  snapshot_arns                = var.snapshot_arns
  snapshot_name                = var.snapshot_name
  snapshot_retention_limit     = var.snapshot_retention_limit
  snapshot_window              = var.snapshot_window
  subnet_group_name            = var.subnet_group_name
  tags                         = var.tags
  transit_encryption_enabled   = var.transit_encryption_enabled

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration
    content {
      destination      = log_delivery_configuration.value.destination
      destination_type = log_delivery_configuration.value.destination_type
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }
}