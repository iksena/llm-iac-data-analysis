resource "aws_storagegateway_tape_pool" "this" {
  region                      = var.region
  pool_name                   = var.pool_name
  storage_class               = var.storage_class
  retention_lock_type         = var.retention_lock_type
  retention_lock_time_in_days = var.retention_lock_time_in_days
  tags                        = var.tags
}