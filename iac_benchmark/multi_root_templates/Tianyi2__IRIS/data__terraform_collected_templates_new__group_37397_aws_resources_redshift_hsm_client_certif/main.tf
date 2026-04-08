resource "aws_redshift_hsm_client_certificate" "this" {
  hsm_client_certificate_identifier = var.hsm_client_certificate_identifier
  region                            = var.region
  tags                              = var.tags
}