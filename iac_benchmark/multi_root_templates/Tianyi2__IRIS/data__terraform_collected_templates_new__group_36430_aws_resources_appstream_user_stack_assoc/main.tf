resource "aws_appstream_user_stack_association" "this" {
  authentication_type     = var.authentication_type
  stack_name              = var.stack_name
  user_name               = var.user_name
  region                  = var.region
  send_email_notification = var.send_email_notification
}