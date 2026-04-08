data "aws_ssoadmin_principal_application_assignments" "this" {
  region         = var.region
  instance_arn   = var.instance_arn
  principal_id   = var.principal_id
  principal_type = var.principal_type
}