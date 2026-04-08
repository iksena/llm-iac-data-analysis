data "aws_serverlessapplicationrepository_application" "this" {
  application_id   = var.application_id
  semantic_version = var.semantic_version
  region           = var.region
}