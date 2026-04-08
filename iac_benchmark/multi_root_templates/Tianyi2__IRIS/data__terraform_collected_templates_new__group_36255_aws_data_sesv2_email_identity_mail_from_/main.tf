data "aws_sesv2_email_identity_mail_from_attributes" "this" {
  email_identity = var.email_identity
  region         = var.region
}