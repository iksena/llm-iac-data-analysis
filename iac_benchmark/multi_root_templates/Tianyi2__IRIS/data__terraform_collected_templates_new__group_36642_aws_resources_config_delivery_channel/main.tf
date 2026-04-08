resource "aws_config_delivery_channel" "this" {
  name           = var.name
  s3_bucket_name = var.s3_bucket_name
  s3_key_prefix  = var.s3_key_prefix
  s3_kms_key_arn = var.s3_kms_key_arn
  sns_topic_arn  = var.sns_topic_arn

  dynamic "snapshot_delivery_properties" {
    for_each = var.snapshot_delivery_properties != null ? [var.snapshot_delivery_properties] : []
    content {
      delivery_frequency = snapshot_delivery_properties.value.delivery_frequency
    }
  }
}