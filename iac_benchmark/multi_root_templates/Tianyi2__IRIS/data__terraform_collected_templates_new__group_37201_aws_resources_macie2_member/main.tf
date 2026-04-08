resource "aws_macie2_member" "this" {
  region                                = var.region
  account_id                            = var.account_id
  email                                 = var.email
  tags                                  = var.tags
  status                                = var.status
  invite                                = var.invite
  invitation_message                    = var.invitation_message
  invitation_disable_email_notification = var.invitation_disable_email_notification
}