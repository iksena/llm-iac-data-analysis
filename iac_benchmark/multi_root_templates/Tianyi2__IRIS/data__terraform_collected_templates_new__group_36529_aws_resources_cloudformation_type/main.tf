resource "aws_cloudformation_type" "this" {
  schema_handler_package = var.schema_handler_package
  region                 = var.region
  execution_role_arn     = var.execution_role_arn
  type                   = var.type
  type_name              = var.type_name

  dynamic "logging_config" {
    for_each = var.logging_config != null ? [var.logging_config] : []
    content {
      log_group_name = logging_config.value.log_group_name
      log_role_arn   = logging_config.value.log_role_arn
    }
  }
}