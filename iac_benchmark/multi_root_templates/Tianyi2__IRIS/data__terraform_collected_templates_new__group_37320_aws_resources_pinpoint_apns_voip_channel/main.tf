resource "aws_pinpoint_apns_voip_channel" "this" {
  region                        = var.region
  application_id                = var.application_id
  enabled                       = var.enabled
  default_authentication_method = var.default_authentication_method

  certificate = var.certificate
  private_key = var.private_key

  bundle_id    = var.bundle_id
  team_id      = var.team_id
  token_key    = var.token_key
  token_key_id = var.token_key_id
}