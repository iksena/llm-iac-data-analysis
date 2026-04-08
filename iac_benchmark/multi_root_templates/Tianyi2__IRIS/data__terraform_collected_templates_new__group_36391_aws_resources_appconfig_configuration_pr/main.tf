resource "aws_appconfig_configuration_profile" "this" {
  region             = var.region
  application_id     = var.application_id
  location_uri       = var.location_uri
  name               = var.name
  description        = var.description
  kms_key_identifier = var.kms_key_identifier
  retrieval_role_arn = var.retrieval_role_arn
  tags               = var.tags
  type               = var.type

  dynamic "validator" {
    for_each = var.validators
    content {
      content = validator.value.content
      type    = validator.value.type
    }
  }
}