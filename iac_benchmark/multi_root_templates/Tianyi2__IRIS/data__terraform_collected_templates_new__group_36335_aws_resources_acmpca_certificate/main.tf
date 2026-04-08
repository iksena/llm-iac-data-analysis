resource "aws_acmpca_certificate" "this" {
  region                      = var.region
  certificate_authority_arn   = var.certificate_authority_arn
  certificate_signing_request = var.certificate_signing_request
  signing_algorithm           = var.signing_algorithm
  template_arn                = var.template_arn
  api_passthrough             = var.api_passthrough

  validity {
    type  = var.validity.type
    value = var.validity.value
  }
}