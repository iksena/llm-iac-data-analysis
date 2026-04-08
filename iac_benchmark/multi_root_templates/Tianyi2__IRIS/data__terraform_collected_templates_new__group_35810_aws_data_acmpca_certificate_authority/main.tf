data "aws_acmpca_certificate_authority" "this" {
  arn    = var.arn
  region = var.region
}