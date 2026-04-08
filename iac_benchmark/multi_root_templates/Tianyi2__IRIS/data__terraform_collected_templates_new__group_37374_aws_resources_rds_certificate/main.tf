resource "aws_rds_certificate" "this" {
  region                 = var.region
  certificate_identifier = var.certificate_identifier
}