resource "aws_apigatewayv2_authorizer" "this" {
  api_id                            = var.api_id
  authorizer_type                   = var.authorizer_type
  name                              = var.name
  authorizer_credentials_arn        = var.authorizer_credentials_arn
  authorizer_payload_format_version = var.authorizer_payload_format_version
  authorizer_result_ttl_in_seconds  = var.authorizer_result_ttl_in_seconds
  authorizer_uri                    = var.authorizer_uri
  enable_simple_responses           = var.enable_simple_responses
  identity_sources                  = var.identity_sources

  dynamic "jwt_configuration" {
    for_each = var.jwt_configuration != null ? [var.jwt_configuration] : []
    content {
      audience = jwt_configuration.value.audience
      issuer   = jwt_configuration.value.issuer
    }
  }
}