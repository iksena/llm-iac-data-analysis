resource "aws_workspacesweb_session_logger_association" "this" {
  portal_arn         = var.portal_arn
  session_logger_arn = var.session_logger_arn
  region             = var.region
}