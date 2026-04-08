resource "aws_workspacesweb_browser_settings_association" "this" {
  browser_settings_arn = var.browser_settings_arn
  portal_arn           = var.portal_arn
  region               = var.region
}