data "aws_ssoadmin_application" "this" {
  application_arn = var.application_arn
  region          = var.region
}