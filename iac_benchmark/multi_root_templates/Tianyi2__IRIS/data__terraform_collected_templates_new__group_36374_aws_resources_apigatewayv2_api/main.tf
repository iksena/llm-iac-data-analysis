resource "aws_apigatewayv2_api" "this" {
  region                       = var.region
  name                         = var.name
  protocol_type                = var.protocol_type
  api_key_selection_expression = var.api_key_selection_expression
  credentials_arn              = var.credentials_arn
  description                  = var.description
  disable_execute_api_endpoint = var.disable_execute_api_endpoint
  ip_address_type              = var.ip_address_type
  route_key                    = var.route_key
  route_selection_expression   = var.route_selection_expression
  tags                         = var.tags
  target                       = var.target
  body                         = var.body
  version                      = var.api_version
  fail_on_warnings             = var.fail_on_warnings

  dynamic "cors_configuration" {
    for_each = var.cors_configuration != null ? [var.cors_configuration] : []
    content {
      allow_credentials = cors_configuration.value.allow_credentials
      allow_headers     = cors_configuration.value.allow_headers
      allow_methods     = cors_configuration.value.allow_methods
      allow_origins     = cors_configuration.value.allow_origins
      expose_headers    = cors_configuration.value.expose_headers
      max_age           = cors_configuration.value.max_age
    }
  }
}