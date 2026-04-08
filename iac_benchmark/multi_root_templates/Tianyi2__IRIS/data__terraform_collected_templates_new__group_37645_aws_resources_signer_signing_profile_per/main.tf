resource "aws_signer_signing_profile_permission" "this" {
  region              = var.region
  profile_name        = var.profile_name
  action              = var.action
  principal           = var.principal
  profile_version     = var.profile_version
  statement_id        = var.statement_id
  statement_id_prefix = var.statement_id_prefix
}