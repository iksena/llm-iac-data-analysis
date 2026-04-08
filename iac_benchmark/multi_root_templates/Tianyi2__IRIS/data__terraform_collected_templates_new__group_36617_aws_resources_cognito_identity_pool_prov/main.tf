resource "aws_cognito_identity_pool_provider_principal_tag" "this" {
  region                 = var.region
  identity_pool_id       = var.identity_pool_id
  identity_provider_name = var.identity_provider_name
  principal_tags         = var.principal_tags
  use_defaults           = var.use_defaults
}