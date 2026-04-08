resource "aws_cloudwatch_log_delivery" "this" {
  region                   = var.region
  delivery_destination_arn = var.delivery_destination_arn
  delivery_source_name     = var.delivery_source_name
  field_delimiter          = var.field_delimiter
  record_fields            = var.record_fields
  tags                     = var.tags

  dynamic "s3_delivery_configuration" {
    for_each = var.s3_delivery_configuration != null ? [var.s3_delivery_configuration] : []
    content {
      enable_hive_compatible_path = s3_delivery_configuration.value.enable_hive_compatible_path
      suffix_path                 = s3_delivery_configuration.value.suffix_path
    }
  }
}