resource "aws_guardduty_member" "this" {
  region                     = var.region
  account_id                 = var.account_id
  detector_id                = var.detector_id
  email                      = var.email
  invite                     = var.invite
  invitation_message         = var.invitation_message
  disable_email_notification = var.disable_email_notification

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      update = timeouts.value.update
    }
  }
}