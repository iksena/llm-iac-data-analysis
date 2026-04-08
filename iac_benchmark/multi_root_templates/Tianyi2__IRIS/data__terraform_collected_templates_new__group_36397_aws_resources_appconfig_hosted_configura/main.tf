resource "aws_appconfig_hosted_configuration_version" "this" {
  region                   = var.region
  application_id           = var.application_id
  configuration_profile_id = var.configuration_profile_id
  content                  = var.content
  content_type             = var.content_type
  description              = var.description
}