resource "aws_serverlessapplicationrepository_cloudformation_stack" "this" {
  region           = var.region
  name             = var.name
  application_id   = var.application_id
  capabilities     = var.capabilities
  parameters       = var.parameters
  semantic_version = var.semantic_version
  tags             = var.tags
}