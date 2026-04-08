data "aws_appconfig_environment" "this" {
  region         = var.region
  application_id = var.application_id
  environment_id = var.environment_id
}