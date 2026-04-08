resource "aws_iot_authorizer" "this" {
  region                    = var.region
  authorizer_function_arn   = var.authorizer_function_arn
  enable_caching_for_http   = var.enable_caching_for_http
  name                      = var.name
  signing_disabled          = var.signing_disabled
  status                    = var.status
  tags                      = var.tags
  token_key_name            = var.token_key_name
  token_signing_public_keys = var.token_signing_public_keys
}