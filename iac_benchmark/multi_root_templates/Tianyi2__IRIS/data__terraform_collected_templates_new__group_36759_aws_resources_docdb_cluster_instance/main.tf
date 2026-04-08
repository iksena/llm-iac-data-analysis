resource "aws_docdb_cluster_instance" "this" {
  region                          = var.region
  apply_immediately               = var.apply_immediately
  auto_minor_version_upgrade      = var.auto_minor_version_upgrade
  availability_zone               = var.availability_zone
  ca_cert_identifier              = var.ca_cert_identifier
  cluster_identifier              = var.cluster_identifier
  copy_tags_to_snapshot           = var.copy_tags_to_snapshot
  enable_performance_insights     = var.enable_performance_insights
  engine                          = var.engine
  identifier                      = var.identifier
  identifier_prefix               = var.identifier_prefix
  instance_class                  = var.instance_class
  performance_insights_kms_key_id = var.performance_insights_kms_key_id
  preferred_maintenance_window    = var.preferred_maintenance_window
  promotion_tier                  = var.promotion_tier
  tags                            = var.tags

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}