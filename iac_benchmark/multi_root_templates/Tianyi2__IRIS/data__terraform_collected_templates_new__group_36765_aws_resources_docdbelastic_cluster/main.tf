resource "aws_docdbelastic_cluster" "this" {
  admin_user_name              = var.admin_user_name
  admin_user_password          = var.admin_user_password
  auth_type                    = var.auth_type
  name                         = var.name
  shard_capacity               = var.shard_capacity
  shard_count                  = var.shard_count
  backup_retention_period      = var.backup_retention_period
  kms_key_id                   = var.kms_key_id
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  subnet_ids                   = var.subnet_ids
  tags                         = var.tags
  vpc_security_group_ids       = var.vpc_security_group_ids

  timeouts {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}