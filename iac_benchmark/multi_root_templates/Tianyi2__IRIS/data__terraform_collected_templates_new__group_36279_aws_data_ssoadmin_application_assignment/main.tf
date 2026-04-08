data "aws_ssoadmin_application_assignments" "this" {
  region          = var.region
  application_arn = var.application_arn
}