resource "aws_appsync_api" "this" {
  name          = var.name
  owner_contact = var.owner_contact
  region        = var.region
  tags          = var.tags

  event_config {
    auth_provider {
      auth_type = var.event_config.auth_provider.auth_type

      dynamic "cognito_config" {
        for_each = var.event_config.auth_provider.cognito_config != null ? [var.event_config.auth_provider.cognito_config] : []
        content {
          app_id_client_regex = cognito_config.value.app_id_client_regex
          aws_region          = cognito_config.value.aws_region
          user_pool_id        = cognito_config.value.user_pool_id
        }
      }

      dynamic "lambda_authorizer_config" {
        for_each = var.event_config.auth_provider.lambda_authorizer_config != null ? [var.event_config.auth_provider.lambda_authorizer_config] : []
        content {
          authorizer_result_ttl_in_seconds = lambda_authorizer_config.value.authorizer_result_ttl_in_seconds
          authorizer_uri                   = lambda_authorizer_config.value.authorizer_uri
          identity_validation_expression   = lambda_authorizer_config.value.identity_validation_expression
        }
      }

      dynamic "openid_connect_config" {
        for_each = var.event_config.auth_provider.openid_connect_config != null ? [var.event_config.auth_provider.openid_connect_config] : []
        content {
          auth_ttl  = openid_connect_config.value.auth_ttl
          client_id = openid_connect_config.value.client_id
          iat_ttl   = openid_connect_config.value.iat_ttl
          issuer    = openid_connect_config.value.issuer
        }
      }
    }

    connection_auth_mode {
      auth_type = var.event_config.connection_auth_mode.auth_type
    }

    default_publish_auth_mode {
      auth_type = var.event_config.default_publish_auth_mode.auth_type
    }

    default_subscribe_auth_mode {
      auth_type = var.event_config.default_subscribe_auth_mode.auth_type
    }

    dynamic "log_config" {
      for_each = var.event_config.log_config != null ? [var.event_config.log_config] : []
      content {
        cloudwatch_logs_role_arn = log_config.value.cloudwatch_logs_role_arn
        log_level                = log_config.value.log_level
      }
    }
  }
}