resource "aws_appsync_graphql_api" "this" {
  authentication_type = var.authentication_type
  name                = var.name

  region                        = var.region
  api_type                      = var.api_type
  introspection_config          = var.introspection_config
  merged_api_execution_role_arn = var.merged_api_execution_role_arn
  query_depth_limit             = var.query_depth_limit
  resolver_count_limit          = var.resolver_count_limit
  schema                        = var.schema
  tags                          = var.tags
  visibility                    = var.visibility
  xray_enabled                  = var.xray_enabled

  dynamic "additional_authentication_provider" {
    for_each = var.additional_authentication_provider != null ? [var.additional_authentication_provider] : []
    content {
      authentication_type = additional_authentication_provider.value.authentication_type

      dynamic "openid_connect_config" {
        for_each = additional_authentication_provider.value.openid_connect_config != null ? [additional_authentication_provider.value.openid_connect_config] : []
        content {
          issuer    = openid_connect_config.value.issuer
          auth_ttl  = openid_connect_config.value.auth_ttl
          client_id = openid_connect_config.value.client_id
          iat_ttl   = openid_connect_config.value.iat_ttl
        }
      }

      dynamic "user_pool_config" {
        for_each = additional_authentication_provider.value.user_pool_config != null ? [additional_authentication_provider.value.user_pool_config] : []
        content {
          user_pool_id        = user_pool_config.value.user_pool_id
          app_id_client_regex = user_pool_config.value.app_id_client_regex
          aws_region          = user_pool_config.value.aws_region
        }
      }
    }
  }

  dynamic "enhanced_metrics_config" {
    for_each = var.enhanced_metrics_config != null ? [var.enhanced_metrics_config] : []
    content {
      data_source_level_metrics_behavior = enhanced_metrics_config.value.data_source_level_metrics_behavior
      operation_level_metrics_config     = enhanced_metrics_config.value.operation_level_metrics_config
      resolver_level_metrics_behavior    = enhanced_metrics_config.value.resolver_level_metrics_behavior
    }
  }

  dynamic "lambda_authorizer_config" {
    for_each = var.lambda_authorizer_config != null ? [var.lambda_authorizer_config] : []
    content {
      authorizer_uri                   = lambda_authorizer_config.value.authorizer_uri
      authorizer_result_ttl_in_seconds = lambda_authorizer_config.value.authorizer_result_ttl_in_seconds
      identity_validation_expression   = lambda_authorizer_config.value.identity_validation_expression
    }
  }

  dynamic "log_config" {
    for_each = var.log_config != null ? [var.log_config] : []
    content {
      cloudwatch_logs_role_arn = log_config.value.cloudwatch_logs_role_arn
      field_log_level          = log_config.value.field_log_level
      exclude_verbose_content  = log_config.value.exclude_verbose_content
    }
  }

  dynamic "openid_connect_config" {
    for_each = var.openid_connect_config != null ? [var.openid_connect_config] : []
    content {
      issuer    = openid_connect_config.value.issuer
      auth_ttl  = openid_connect_config.value.auth_ttl
      client_id = openid_connect_config.value.client_id
      iat_ttl   = openid_connect_config.value.iat_ttl
    }
  }

  dynamic "user_pool_config" {
    for_each = var.user_pool_config != null ? [var.user_pool_config] : []
    content {
      user_pool_id        = user_pool_config.value.user_pool_id
      app_id_client_regex = user_pool_config.value.app_id_client_regex
      aws_region          = user_pool_config.value.aws_region
      default_action      = user_pool_config.value.default_action
    }
  }
}