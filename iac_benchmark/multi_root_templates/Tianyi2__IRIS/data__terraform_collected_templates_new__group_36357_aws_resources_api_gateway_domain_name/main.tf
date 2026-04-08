resource "aws_api_gateway_domain_name" "this" {
  region                                 = var.region
  domain_name                            = var.domain_name
  policy                                 = var.policy
  ownership_verification_certificate_arn = var.ownership_verification_certificate_arn
  security_policy                        = var.security_policy
  tags                                   = var.tags

  certificate_arn           = var.certificate_arn
  regional_certificate_arn  = var.regional_certificate_arn
  certificate_body          = var.certificate_body
  certificate_chain         = var.certificate_chain
  certificate_name          = var.certificate_name
  certificate_private_key   = var.certificate_private_key
  regional_certificate_name = var.regional_certificate_name

  dynamic "endpoint_configuration" {
    for_each = var.endpoint_configuration != null ? [var.endpoint_configuration] : []
    content {
      ip_address_type = endpoint_configuration.value.ip_address_type
      types           = endpoint_configuration.value.types
    }
  }

  dynamic "mutual_tls_authentication" {
    for_each = var.mutual_tls_authentication != null ? [var.mutual_tls_authentication] : []
    content {
      truststore_uri     = mutual_tls_authentication.value.truststore_uri
      truststore_version = mutual_tls_authentication.value.truststore_version
    }
  }
}