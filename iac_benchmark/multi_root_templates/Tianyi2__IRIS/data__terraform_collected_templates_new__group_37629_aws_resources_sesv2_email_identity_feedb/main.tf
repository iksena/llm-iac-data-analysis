resource "aws_sesv2_email_identity_feedback_attributes" "this" {
  region                   = var.region
  email_identity           = var.email_identity
  email_forwarding_enabled = var.email_forwarding_enabled
}