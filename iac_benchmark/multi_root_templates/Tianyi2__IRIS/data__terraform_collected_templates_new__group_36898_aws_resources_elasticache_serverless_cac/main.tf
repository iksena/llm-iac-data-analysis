resource "aws_elasticache_serverless_cache" "this" {
  engine = var.engine
  name   = var.name

  region = var.region

  dynamic "cache_usage_limits" {
    for_each = var.cache_usage_limits != null ? [var.cache_usage_limits] : []
    content {
      dynamic "data_storage" {
        for_each = cache_usage_limits.value.data_storage != null ? [cache_usage_limits.value.data_storage] : []
        content {
          minimum = data_storage.value.minimum
          maximum = data_storage.value.maximum
          unit    = data_storage.value.unit
        }
      }

      dynamic "ecpu_per_second" {
        for_each = cache_usage_limits.value.ecpu_per_second != null ? [cache_usage_limits.value.ecpu_per_second] : []
        content {
          minimum = ecpu_per_second.value.minimum
          maximum = ecpu_per_second.value.maximum
        }
      }
    }
  }

  daily_snapshot_time      = var.daily_snapshot_time
  description              = var.description
  kms_key_id               = var.kms_key_id
  major_engine_version     = var.major_engine_version
  security_group_ids       = var.security_group_ids
  snapshot_arns_to_restore = var.snapshot_arns_to_restore
  snapshot_retention_limit = var.snapshot_retention_limit
  subnet_ids               = var.subnet_ids
  tags                     = var.tags
  user_group_id            = var.user_group_id

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}