resource "aws_acmpca_certificate_authority_certificate" "this" {
  region                    = var.region
  certificate               = var.certificate
  certificate_authority_arn = var.certificate_authority_arn
  certificate_chain         = var.certificate_chain
}