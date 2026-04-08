resource "aws_codepipeline_custom_action_type" "this" {
  region        = var.region
  category      = var.category
  provider_name = var.provider_name
  version       = var.action_version

  dynamic "configuration_property" {
    for_each = var.configuration_property != null ? var.configuration_property : []
    content {
      description = configuration_property.value.description
      key         = configuration_property.value.key
      name        = configuration_property.value.name
      queryable   = configuration_property.value.queryable
      required    = configuration_property.value.required
      secret      = configuration_property.value.secret
      type        = configuration_property.value.type
    }
  }

  input_artifact_details {
    maximum_count = var.input_artifact_details.maximum_count
    minimum_count = var.input_artifact_details.minimum_count
  }

  output_artifact_details {
    maximum_count = var.output_artifact_details.maximum_count
    minimum_count = var.output_artifact_details.minimum_count
  }

  dynamic "settings" {
    for_each = var.settings != null ? [var.settings] : []
    content {
      entity_url_template           = settings.value.entity_url_template
      execution_url_template        = settings.value.execution_url_template
      revision_url_template         = settings.value.revision_url_template
      third_party_configuration_url = settings.value.third_party_configuration_url
    }
  }

  tags = var.tags
}