resource "aws_cognito_identity_provider" "this" {
  user_pool_id  = var.user_pool_id
  provider_name = var.provider_name
  provider_type = var.provider_type

  attribute_mapping = var.attribute_mapping
  idp_identifiers   = var.idp_identifiers
  provider_details  = var.provider_details
}