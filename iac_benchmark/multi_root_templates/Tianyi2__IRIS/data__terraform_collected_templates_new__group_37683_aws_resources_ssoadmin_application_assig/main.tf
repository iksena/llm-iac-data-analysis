resource "aws_ssoadmin_application_assignment_configuration" "this" {
  region              = var.region
  application_arn     = var.application_arn
  assignment_required = var.assignment_required
}