resource "aws_appstream_stack" "this" {
  name               = var.name
  region             = var.region
  description        = var.description
  display_name       = var.display_name
  embed_host_domains = var.embed_host_domains
  feedback_url       = var.feedback_url
  redirect_url       = var.redirect_url
  tags               = var.tags

  dynamic "access_endpoints" {
    for_each = var.access_endpoints
    content {
      endpoint_type = access_endpoints.value.endpoint_type
      vpce_id       = access_endpoints.value.vpce_id
    }
  }

  dynamic "application_settings" {
    for_each = var.application_settings != null ? [var.application_settings] : []
    content {
      enabled        = application_settings.value.enabled
      settings_group = application_settings.value.settings_group
    }
  }

  dynamic "storage_connectors" {
    for_each = var.storage_connectors
    content {
      connector_type      = storage_connectors.value.connector_type
      domains             = storage_connectors.value.domains
      resource_identifier = storage_connectors.value.resource_identifier
    }
  }

  dynamic "user_settings" {
    for_each = var.user_settings
    content {
      action     = user_settings.value.action
      permission = user_settings.value.permission
    }
  }

  dynamic "streaming_experience_settings" {
    for_each = var.streaming_experience_settings != null ? [var.streaming_experience_settings] : []
    content {
      preferred_protocol = streaming_experience_settings.value.preferred_protocol
    }
  }
}