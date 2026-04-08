resource "aws_ssoadmin_trusted_token_issuer" "this" {
  instance_arn              = var.instance_arn
  name                      = var.name
  trusted_token_issuer_type = var.trusted_token_issuer_type
  region                    = var.region
  client_token              = var.client_token
  tags                      = var.tags

  dynamic "trusted_token_issuer_configuration" {
    for_each = var.trusted_token_issuer_configuration != null ? [var.trusted_token_issuer_configuration] : []
    content {
      dynamic "oidc_jwt_configuration" {
        for_each = trusted_token_issuer_configuration.value.oidc_jwt_configuration != null ? [trusted_token_issuer_configuration.value.oidc_jwt_configuration] : []
        content {
          claim_attribute_path          = oidc_jwt_configuration.value.claim_attribute_path
          identity_store_attribute_path = oidc_jwt_configuration.value.identity_store_attribute_path
          issuer_url                    = oidc_jwt_configuration.value.issuer_url
          jwks_retrieval_option         = oidc_jwt_configuration.value.jwks_retrieval_option
        }
      }
    }
  }
}