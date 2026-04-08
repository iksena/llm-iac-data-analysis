resource "aws_sesv2_email_identity_policy" "this" {
  region         = var.region
  email_identity = var.email_identity
  policy_name    = var.policy_name
  policy         = var.policy
}