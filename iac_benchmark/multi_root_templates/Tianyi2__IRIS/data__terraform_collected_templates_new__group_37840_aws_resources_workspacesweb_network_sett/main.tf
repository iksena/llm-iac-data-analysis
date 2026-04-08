resource "aws_workspacesweb_network_settings_association" "this" {
  network_settings_arn = var.network_settings_arn
  portal_arn           = var.portal_arn
  region               = var.region
}