resource "aws_detective_member" "this" {
  region                     = var.region
  account_id                 = var.account_id
  email_address              = var.email_address
  graph_arn                  = var.graph_arn
  message                    = var.message
  disable_email_notification = var.disable_email_notification
}