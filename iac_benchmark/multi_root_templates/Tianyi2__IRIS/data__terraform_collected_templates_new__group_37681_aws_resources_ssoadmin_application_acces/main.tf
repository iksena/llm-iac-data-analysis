resource "aws_ssoadmin_application_access_scope" "this" {
  application_arn    = var.application_arn
  scope              = var.scope
  authorized_targets = var.authorized_targets
  region             = var.region
}