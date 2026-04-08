data "aws_ses_email_identity" "this" {
  email  = var.email
  region = var.region
}