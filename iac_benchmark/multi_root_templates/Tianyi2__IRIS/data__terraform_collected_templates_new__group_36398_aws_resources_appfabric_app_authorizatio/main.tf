resource "aws_appfabric_app_authorization" "this" {
  region         = var.region
  app            = var.app
  app_bundle_arn = var.app_bundle_arn
  auth_type      = var.auth_type

  credential {
    dynamic "api_key_credential" {
      for_each = var.api_key_credential != null ? [var.api_key_credential] : []
      content {
        api_key = api_key_credential.value.api_key
      }
    }

    dynamic "oauth2_credential" {
      for_each = var.oauth2_credential != null ? [var.oauth2_credential] : []
      content {
        client_id     = oauth2_credential.value.client_id
        client_secret = oauth2_credential.value.client_secret
      }
    }
  }

  tenant {
    tenant_display_name = var.tenant.tenant_display_name
    tenant_identifier   = var.tenant.tenant_identifier
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}