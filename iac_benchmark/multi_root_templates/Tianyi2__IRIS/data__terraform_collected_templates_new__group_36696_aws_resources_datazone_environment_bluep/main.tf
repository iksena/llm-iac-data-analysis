resource "aws_datazone_environment_blueprint_configuration" "this" {
  domain_id                = var.domain_id
  environment_blueprint_id = var.environment_blueprint_id
  enabled_regions          = var.enabled_regions

  manage_access_role_arn = var.manage_access_role_arn
  provisioning_role_arn  = var.provisioning_role_arn
  regional_parameters    = var.regional_parameters
}