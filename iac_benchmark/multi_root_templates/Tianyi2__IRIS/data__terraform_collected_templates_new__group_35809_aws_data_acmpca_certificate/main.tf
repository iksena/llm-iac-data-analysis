data "aws_acmpca_certificate" "this" {
  arn                       = var.arn
  certificate_authority_arn = var.certificate_authority_arn
}