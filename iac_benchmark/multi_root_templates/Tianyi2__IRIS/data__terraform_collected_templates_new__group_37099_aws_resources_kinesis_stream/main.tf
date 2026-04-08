resource "aws_kinesis_stream" "this" {
  region                    = var.region
  name                      = var.name
  shard_count               = var.shard_count
  retention_period          = var.retention_period
  shard_level_metrics       = var.shard_level_metrics
  enforce_consumer_deletion = var.enforce_consumer_deletion
  encryption_type           = var.encryption_type
  kms_key_id                = var.kms_key_id
  tags                      = var.tags

  dynamic "stream_mode_details" {
    for_each = var.stream_mode_details != null ? [var.stream_mode_details] : []
    content {
      stream_mode = stream_mode_details.value.stream_mode
    }
  }

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}