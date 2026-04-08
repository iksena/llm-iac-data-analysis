resource "aws_sagemaker_workforce" "this" {
  region         = var.region
  workforce_name = var.workforce_name

  dynamic "cognito_config" {
    for_each = var.cognito_config != null ? [var.cognito_config] : []
    content {
      client_id = cognito_config.value.client_id
      user_pool = cognito_config.value.user_pool
    }
  }

  dynamic "oidc_config" {
    for_each = var.oidc_config != null ? [var.oidc_config] : []
    content {
      authentication_request_extra_params = oidc_config.value.authentication_request_extra_params
      authorization_endpoint              = oidc_config.value.authorization_endpoint
      client_id                           = oidc_config.value.client_id
      client_secret                       = oidc_config.value.client_secret
      issuer                              = oidc_config.value.issuer
      jwks_uri                            = oidc_config.value.jwks_uri
      logout_endpoint                     = oidc_config.value.logout_endpoint
      scope                               = oidc_config.value.scope
      token_endpoint                      = oidc_config.value.token_endpoint
      user_info_endpoint                  = oidc_config.value.user_info_endpoint
    }
  }

  dynamic "source_ip_config" {
    for_each = var.source_ip_config != null ? [var.source_ip_config] : []
    content {
      cidrs = source_ip_config.value.cidrs
    }
  }

  dynamic "workforce_vpc_config" {
    for_each = var.workforce_vpc_config != null ? [var.workforce_vpc_config] : []
    content {
      security_group_ids = workforce_vpc_config.value.security_group_ids
      subnets            = workforce_vpc_config.value.subnets
      vpc_id             = workforce_vpc_config.value.vpc_id
    }
  }
}