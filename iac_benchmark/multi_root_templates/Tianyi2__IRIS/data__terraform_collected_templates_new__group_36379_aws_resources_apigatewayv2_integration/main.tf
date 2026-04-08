resource "aws_apigatewayv2_integration" "this" {
  provider = aws.region

  api_id                        = var.api_id
  integration_type              = var.integration_type
  connection_id                 = var.connection_id
  connection_type               = var.connection_type
  content_handling_strategy     = var.content_handling_strategy
  credentials_arn               = var.credentials_arn
  description                   = var.description
  integration_method            = var.integration_method
  integration_subtype           = var.integration_subtype
  integration_uri               = var.integration_uri
  passthrough_behavior          = var.passthrough_behavior
  payload_format_version        = var.payload_format_version
  request_parameters            = var.request_parameters
  request_templates             = var.request_templates
  template_selection_expression = var.template_selection_expression
  timeout_milliseconds          = var.timeout_milliseconds

  dynamic "response_parameters" {
    for_each = var.response_parameters
    content {
      status_code = response_parameters.value.status_code
      mappings    = response_parameters.value.mappings
    }
  }

  dynamic "tls_config" {
    for_each = var.tls_config != null ? [var.tls_config] : []
    content {
      server_name_to_verify = tls_config.value.server_name_to_verify
    }
  }
}