resource "aws_dms_certificate" "this" {
  region             = var.region
  certificate_id     = var.certificate_id
  certificate_pem    = var.certificate_pem
  certificate_wallet = var.certificate_wallet
  tags               = var.tags
}