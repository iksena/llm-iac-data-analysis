resource "aws_workspacesweb_ip_access_settings_association" "this" {
  ip_access_settings_arn = var.ip_access_settings_arn
  portal_arn             = var.portal_arn
  region                 = var.region
}