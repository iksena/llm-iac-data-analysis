resource "aws_dx_macsec_key_association" "this" {
  region        = var.region
  cak           = var.cak
  ckn           = var.ckn
  connection_id = var.connection_id
  secret_arn    = var.secret_arn
}