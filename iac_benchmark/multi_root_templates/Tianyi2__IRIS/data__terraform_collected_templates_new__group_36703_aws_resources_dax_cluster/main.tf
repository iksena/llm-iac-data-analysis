resource "aws_dax_cluster" "this" {
  cluster_name                     = var.cluster_name
  iam_role_arn                     = var.iam_role_arn
  node_type                        = var.node_type
  replication_factor               = var.replication_factor
  region                           = var.region
  cluster_endpoint_encryption_type = var.cluster_endpoint_encryption_type
  availability_zones               = var.availability_zones
  description                      = var.description
  notification_topic_arn           = var.notification_topic_arn
  parameter_group_name             = var.parameter_group_name
  maintenance_window               = var.maintenance_window
  security_group_ids               = var.security_group_ids
  subnet_group_name                = var.subnet_group_name
  tags                             = var.tags

  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption != null ? [var.server_side_encryption] : []
    content {
      enabled = server_side_encryption.value.enabled
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}