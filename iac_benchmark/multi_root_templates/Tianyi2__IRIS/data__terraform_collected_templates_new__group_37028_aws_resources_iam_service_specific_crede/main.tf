resource "aws_iam_service_specific_credential" "this" {
  service_name = var.service_name
  user_name    = var.user_name
  status       = var.status
}