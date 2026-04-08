resource "aws_iot_domain_configuration" "this" {
  name                       = var.name
  region                     = var.region
  application_protocol       = var.application_protocol
  authentication_type        = var.authentication_type
  domain_name                = var.domain_name
  server_certificate_arns    = var.server_certificate_arns
  service_type               = var.service_type
  status                     = var.status
  tags                       = var.tags
  validation_certificate_arn = var.validation_certificate_arn

  dynamic "authorizer_config" {
    for_each = var.authorizer_config != null ? [var.authorizer_config] : []
    content {
      allow_authorizer_override = authorizer_config.value.allow_authorizer_override
      default_authorizer_name   = authorizer_config.value.default_authorizer_name
    }
  }

  dynamic "tls_config" {
    for_each = var.tls_config != null ? [var.tls_config] : []
    content {
      security_policy = tls_config.value.security_policy
    }
  }
}