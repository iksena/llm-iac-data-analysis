data "aws_appconfig_configuration_profile" "this" {
  region                   = var.region
  application_id           = var.application_id
  configuration_profile_id = var.configuration_profile_id
}