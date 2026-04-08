resource "aws_appconfig_deployment" "this" {
  application_id           = var.application_id
  configuration_profile_id = var.configuration_profile_id
  configuration_version    = var.configuration_version
  deployment_strategy_id   = var.deployment_strategy_id
  environment_id           = var.environment_id

  description        = var.description
  kms_key_identifier = var.kms_key_identifier

  tags = var.tags
}