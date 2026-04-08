resource "aws_cleanrooms_membership" "this" {
  region           = var.region
  collaboration_id = var.collaboration_id
  query_log_status = var.query_log_status

  dynamic "default_result_configuration" {
    for_each = var.default_result_configuration != null ? [var.default_result_configuration] : []
    content {
      role_arn = default_result_configuration.value.role_arn

      output_configuration {
        s3 {
          bucket        = default_result_configuration.value.output_configuration.s3.bucket
          result_format = default_result_configuration.value.output_configuration.s3.result_format
          key_prefix    = default_result_configuration.value.output_configuration.s3.key_prefix
        }
      }
    }
  }

  tags = var.tags
}