resource "aws_acmpca_permission" "this" {
  certificate_authority_arn = var.certificate_authority_arn
  actions                   = var.actions
  principal                 = var.principal
  source_account            = var.source_account
  region                    = var.region
}