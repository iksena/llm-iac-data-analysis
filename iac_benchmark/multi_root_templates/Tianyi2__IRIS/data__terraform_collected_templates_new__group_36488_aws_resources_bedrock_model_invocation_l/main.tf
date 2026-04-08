resource "aws_bedrock_model_invocation_logging_configuration" "this" {
  region = var.region

  logging_config {
    embedding_data_delivery_enabled = var.embedding_data_delivery_enabled
    image_data_delivery_enabled     = var.image_data_delivery_enabled
    text_data_delivery_enabled      = var.text_data_delivery_enabled
    video_data_delivery_enabled     = var.video_data_delivery_enabled

    dynamic "cloudwatch_config" {
      for_each = var.cloudwatch_config != null ? [var.cloudwatch_config] : []
      content {
        log_group_name = cloudwatch_config.value.log_group_name
        role_arn       = cloudwatch_config.value.role_arn

        dynamic "large_data_delivery_s3_config" {
          for_each = cloudwatch_config.value.large_data_delivery_s3_config != null ? [cloudwatch_config.value.large_data_delivery_s3_config] : []
          content {
            bucket_name = large_data_delivery_s3_config.value.bucket_name
            key_prefix  = large_data_delivery_s3_config.value.key_prefix
          }
        }
      }
    }

    dynamic "s3_config" {
      for_each = var.s3_config != null ? [var.s3_config] : []
      content {
        bucket_name = s3_config.value.bucket_name
        key_prefix  = s3_config.value.key_prefix
      }
    }
  }
}