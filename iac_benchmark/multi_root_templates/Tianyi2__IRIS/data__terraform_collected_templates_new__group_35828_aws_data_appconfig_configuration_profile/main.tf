data "aws_appconfig_configuration_profiles" "this" {
  application_id = var.application_id
  region         = var.region
}