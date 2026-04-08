resource "aws_notificationscontacts_email_contact" "this" {
  email_address = var.email_address
  name          = var.name
  tags          = var.tags
}