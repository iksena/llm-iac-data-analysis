resource "aws_workspacesweb_user_settings_association" "this" {
  user_settings_arn = var.user_settings_arn
  portal_arn        = var.portal_arn
  region            = var.region
}