data "aws_dms_certificate" "this" {
  certificate_id = var.certificate_id
  region         = var.region
}