resource "aws_cognito_managed_user_pool_client" "this" {
  user_pool_id = var.user_pool_id
  name_pattern = var.name_pattern
  name_prefix  = var.name_prefix
  region       = var.region

  access_token_validity                         = var.access_token_validity
  allowed_oauth_flows_user_pool_client          = var.allowed_oauth_flows_user_pool_client
  allowed_oauth_flows                           = var.allowed_oauth_flows
  allowed_oauth_scopes                          = var.allowed_oauth_scopes
  auth_session_validity                         = var.auth_session_validity
  callback_urls                                 = var.callback_urls
  default_redirect_uri                          = var.default_redirect_uri
  enable_token_revocation                       = var.enable_token_revocation
  enable_propagate_additional_user_context_data = var.enable_propagate_additional_user_context_data
  explicit_auth_flows                           = var.explicit_auth_flows
  id_token_validity                             = var.id_token_validity
  logout_urls                                   = var.logout_urls
  prevent_user_existence_errors                 = var.prevent_user_existence_errors
  read_attributes                               = var.read_attributes
  refresh_token_validity                        = var.refresh_token_validity
  supported_identity_providers                  = var.supported_identity_providers
  write_attributes                              = var.write_attributes

  dynamic "analytics_configuration" {
    for_each = var.analytics_configuration != null ? [var.analytics_configuration] : []
    content {
      application_arn  = analytics_configuration.value.application_arn
      application_id   = analytics_configuration.value.application_id
      external_id      = analytics_configuration.value.external_id
      role_arn         = analytics_configuration.value.role_arn
      user_data_shared = analytics_configuration.value.user_data_shared
    }
  }

  dynamic "refresh_token_rotation" {
    for_each = var.refresh_token_rotation != null ? [var.refresh_token_rotation] : []
    content {
      feature                    = refresh_token_rotation.value.feature
      retry_grace_period_seconds = refresh_token_rotation.value.retry_grace_period_seconds
    }
  }

  dynamic "token_validity_units" {
    for_each = var.token_validity_units != null ? [var.token_validity_units] : []
    content {
      access_token  = token_validity_units.value.access_token
      id_token      = token_validity_units.value.id_token
      refresh_token = token_validity_units.value.refresh_token
    }
  }
}