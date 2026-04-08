resource "aws_rds_cluster_role_association" "this" {
  region                = var.region
  db_cluster_identifier = var.db_cluster_identifier
  feature_name          = var.feature_name
  role_arn              = var.role_arn

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      delete = timeouts.value.delete
    }
  }
}