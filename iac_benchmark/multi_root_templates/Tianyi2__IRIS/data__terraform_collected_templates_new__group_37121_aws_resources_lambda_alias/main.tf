resource "aws_lambda_alias" "this" {
  name             = var.name
  function_name    = var.function_name
  function_version = var.function_version
  description      = var.description
  region           = var.region

  dynamic "routing_config" {
    for_each = var.routing_config != null ? [var.routing_config] : []
    content {
      additional_version_weights = routing_config.value.additional_version_weights
    }
  }
}