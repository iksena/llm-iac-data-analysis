resource "aws_iot_certificate" "this" {
  region          = var.region
  active          = var.active
  csr             = var.csr
  certificate_pem = var.certificate_pem
  ca_pem          = var.ca_pem
}