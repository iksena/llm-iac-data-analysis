resource "aws_api_gateway_method" "this" {
  region               = var.region
  rest_api_id          = var.rest_api_id
  resource_id          = var.resource_id
  http_method          = var.http_method
  authorization        = var.authorization
  authorizer_id        = var.authorizer_id
  authorization_scopes = var.authorization_scopes
  api_key_required     = var.api_key_required
  operation_name       = var.operation_name
  request_models       = var.request_models
  request_validator_id = var.request_validator_id
  request_parameters   = var.request_parameters
}