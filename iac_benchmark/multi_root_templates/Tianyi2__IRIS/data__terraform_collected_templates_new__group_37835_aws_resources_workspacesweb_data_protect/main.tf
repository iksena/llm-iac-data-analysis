resource "aws_workspacesweb_data_protection_settings_association" "this" {
  data_protection_settings_arn = var.data_protection_settings_arn
  portal_arn                   = var.portal_arn
  region                       = var.region
}