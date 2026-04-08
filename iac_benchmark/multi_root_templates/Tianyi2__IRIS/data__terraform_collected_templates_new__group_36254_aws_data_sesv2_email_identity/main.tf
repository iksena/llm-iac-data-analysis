data "aws_sesv2_email_identity" "this" {
  email_identity = var.email_identity
  region         = var.region
}