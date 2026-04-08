resource "aws_iam_signing_certificate" "this" {
  certificate_body = var.certificate_body
  status           = var.status
  user_name        = var.user_name
}