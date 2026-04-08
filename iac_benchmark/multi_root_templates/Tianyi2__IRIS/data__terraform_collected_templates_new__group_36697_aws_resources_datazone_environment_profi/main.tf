resource "aws_datazone_environment_profile" "this" {
  aws_account_id                   = var.aws_account_id
  aws_account_region               = var.aws_account_region
  domain_identifier                = var.domain_identifier
  name                             = var.name
  environment_blueprint_identifier = var.environment_blueprint_identifier
  project_identifier               = var.project_identifier
  description                      = var.description

  dynamic "user_parameters" {
    for_each = var.user_parameters
    content {
      name  = user_parameters.value.name
      value = user_parameters.value.value
    }
  }
}