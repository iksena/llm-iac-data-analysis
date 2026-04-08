resource "aws_ssoadmin_application_assignment" "this" {
  application_arn = var.application_arn
  principal_id    = var.principal_id
  principal_type  = var.principal_type
}