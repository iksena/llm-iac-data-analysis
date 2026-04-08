resource "aws_transfer_agreement" "this" {
  access_role        = var.access_role
  base_directory     = var.base_directory
  description        = var.description
  local_profile_id   = var.local_profile_id
  partner_profile_id = var.partner_profile_id
  server_id          = var.server_id
  tags               = var.tags
}