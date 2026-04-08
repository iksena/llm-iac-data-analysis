resource "aws_apigatewayv2_domain_name" "this" {
  region      = var.region
  domain_name = var.domain_name
  tags        = var.tags

  domain_name_configuration {
    certificate_arn                        = var.domain_name_configuration.certificate_arn
    endpoint_type                          = var.domain_name_configuration.endpoint_type
    ip_address_type                        = var.domain_name_configuration.ip_address_type
    ownership_verification_certificate_arn = var.domain_name_configuration.ownership_verification_certificate_arn
    security_policy                        = var.domain_name_configuration.security_policy
  }

  dynamic "mutual_tls_authentication" {
    for_each = var.mutual_tls_authentication != null ? [var.mutual_tls_authentication] : []
    content {
      truststore_uri     = mutual_tls_authentication.value.truststore_uri
      truststore_version = mutual_tls_authentication.value.truststore_version
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
  }
}