resource "aws_workspacesweb_user_access_logging_settings_association" "this" {
  user_access_logging_settings_arn = var.user_access_logging_settings_arn
  portal_arn                       = var.portal_arn
  region                           = var.region
}