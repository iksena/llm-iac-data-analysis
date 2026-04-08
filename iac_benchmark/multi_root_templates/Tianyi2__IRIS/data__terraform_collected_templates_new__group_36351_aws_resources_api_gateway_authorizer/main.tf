resource "aws_api_gateway_authorizer" "this" {
  region                           = var.region
  authorizer_uri                   = var.authorizer_uri
  name                             = var.name
  rest_api_id                      = var.rest_api_id
  identity_source                  = var.identity_source
  type                             = var.type
  authorizer_credentials           = var.authorizer_credentials
  authorizer_result_ttl_in_seconds = var.authorizer_result_ttl_in_seconds
  identity_validation_expression   = var.identity_validation_expression
  provider_arns                    = var.provider_arns
}