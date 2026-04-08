resource "aws_sesv2_email_identity_mail_from_attributes" "this" {
  region                 = var.region
  email_identity         = var.email_identity
  behavior_on_mx_failure = var.behavior_on_mx_failure
  mail_from_domain       = var.mail_from_domain
}