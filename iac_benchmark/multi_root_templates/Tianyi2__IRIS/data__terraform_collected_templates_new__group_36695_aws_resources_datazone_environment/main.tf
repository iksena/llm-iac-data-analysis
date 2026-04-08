resource "aws_datazone_environment" "this" {
  domain_identifier    = var.domain_identifier
  name                 = var.name
  profile_identifier   = var.profile_identifier
  project_identifier   = var.project_identifier
  region               = var.region
  account_identifier   = var.account_identifier
  account_region       = var.account_region
  blueprint_identifier = var.blueprint_identifier
  description          = var.description
  glossary_terms       = var.glossary_terms

  dynamic "user_parameters" {
    for_each = var.user_parameters
    content {
      name  = user_parameters.value.name
      value = user_parameters.value.value
    }
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}