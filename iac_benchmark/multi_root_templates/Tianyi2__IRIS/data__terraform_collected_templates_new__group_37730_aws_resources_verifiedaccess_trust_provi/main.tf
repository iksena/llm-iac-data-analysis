resource "aws_verifiedaccess_trust_provider" "this" {
  policy_reference_name      = var.policy_reference_name
  trust_provider_type        = var.trust_provider_type
  region                     = var.region
  description                = var.description
  device_trust_provider_type = var.device_trust_provider_type
  user_trust_provider_type   = var.user_trust_provider_type
  tags                       = var.tags

  dynamic "device_options" {
    for_each = var.device_options != null ? [var.device_options] : []
    content {
      tenant_id = device_options.value.tenant_id
    }
  }

  dynamic "native_application_oidc_options" {
    for_each = var.native_application_oidc_options != null ? [var.native_application_oidc_options] : []
    content {
      client_id              = native_application_oidc_options.value.client_id
      client_secret          = native_application_oidc_options.value.client_secret
      issuer                 = native_application_oidc_options.value.issuer
      authorization_endpoint = native_application_oidc_options.value.authorization_endpoint
      token_endpoint         = native_application_oidc_options.value.token_endpoint
      user_info_endpoint     = native_application_oidc_options.value.user_info_endpoint
      scope                  = native_application_oidc_options.value.scope
    }
  }

  dynamic "oidc_options" {
    for_each = var.oidc_options != null ? [var.oidc_options] : []
    content {
      client_id              = oidc_options.value.client_id
      client_secret          = oidc_options.value.client_secret
      issuer                 = oidc_options.value.issuer
      authorization_endpoint = oidc_options.value.authorization_endpoint
      token_endpoint         = oidc_options.value.token_endpoint
      user_info_endpoint     = oidc_options.value.user_info_endpoint
      scope                  = oidc_options.value.scope
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}