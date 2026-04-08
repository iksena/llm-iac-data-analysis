resource "aws_appstream_user" "this" {
  authentication_type     = var.authentication_type
  user_name               = var.user_name
  region                  = var.region
  enabled                 = var.enabled
  first_name              = var.first_name
  last_name               = var.last_name
  send_email_notification = var.send_email_notification
}