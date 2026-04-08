resource "aws_amplify_backend_environment" "this" {
  region               = var.region
  app_id               = var.app_id
  environment_name     = var.environment_name
  deployment_artifacts = var.deployment_artifacts
  stack_name           = var.stack_name
}