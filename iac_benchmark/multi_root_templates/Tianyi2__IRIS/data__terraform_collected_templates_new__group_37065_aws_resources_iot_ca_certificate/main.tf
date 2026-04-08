resource "aws_iot_ca_certificate" "this" {
  region                       = var.region
  active                       = var.active
  allow_auto_registration      = var.allow_auto_registration
  ca_certificate_pem           = var.ca_certificate_pem
  certificate_mode             = var.certificate_mode
  verification_certificate_pem = var.verification_certificate_pem
  tags                         = var.tags

  dynamic "registration_config" {
    for_each = var.registration_config != null ? [var.registration_config] : []
    content {
      role_arn      = registration_config.value.role_arn
      template_body = registration_config.value.template_body
      template_name = registration_config.value.template_name
    }
  }
}