resource "aws_pinpoint_apns_voip_sandbox_channel" "this" {
  application_id                = var.application_id
  enabled                       = var.enabled
  default_authentication_method = var.default_authentication_method

  # Certificate credentials
  certificate = var.certificate
  private_key = var.private_key

  # Key credentials
  bundle_id    = var.bundle_id
  team_id      = var.team_id
  token_key    = var.token_key
  token_key_id = var.token_key_id
}