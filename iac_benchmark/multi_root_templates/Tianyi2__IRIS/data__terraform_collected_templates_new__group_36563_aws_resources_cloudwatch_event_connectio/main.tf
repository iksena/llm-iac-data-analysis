resource "aws_cloudwatch_event_connection" "this" {
  region             = var.region
  name               = var.name
  description        = var.description
  authorization_type = var.authorization_type
  kms_key_identifier = var.kms_key_identifier

  auth_parameters {
    dynamic "api_key" {
      for_each = var.auth_parameters_api_key != null ? [var.auth_parameters_api_key] : []
      content {
        key   = api_key.value.key
        value = api_key.value.value
      }
    }

    dynamic "basic" {
      for_each = var.auth_parameters_basic != null ? [var.auth_parameters_basic] : []
      content {
        username = basic.value.username
        password = basic.value.password
      }
    }

    dynamic "oauth" {
      for_each = var.auth_parameters_oauth != null ? [var.auth_parameters_oauth] : []
      content {
        authorization_endpoint = oauth.value.authorization_endpoint
        http_method            = oauth.value.http_method

        client_parameters {
          client_id     = oauth.value.client_parameters.client_id
          client_secret = oauth.value.client_parameters.client_secret
        }

        oauth_http_parameters {
          dynamic "body" {
            for_each = oauth.value.oauth_http_parameters.body
            content {
              key             = body.value.key
              value           = body.value.value
              is_value_secret = body.value.is_value_secret
            }
          }

          dynamic "header" {
            for_each = oauth.value.oauth_http_parameters.header
            content {
              key             = header.value.key
              value           = header.value.value
              is_value_secret = header.value.is_value_secret
            }
          }

          dynamic "query_string" {
            for_each = oauth.value.oauth_http_parameters.query_string
            content {
              key             = query_string.value.key
              value           = query_string.value.value
              is_value_secret = query_string.value.is_value_secret
            }
          }
        }
      }
    }

    dynamic "invocation_http_parameters" {
      for_each = var.auth_parameters_invocation_http_parameters != null ? [var.auth_parameters_invocation_http_parameters] : []
      content {
        dynamic "body" {
          for_each = invocation_http_parameters.value.body
          content {
            key             = body.value.key
            value           = body.value.value
            is_value_secret = body.value.is_value_secret
          }
        }

        dynamic "header" {
          for_each = invocation_http_parameters.value.header
          content {
            key             = header.value.key
            value           = header.value.value
            is_value_secret = header.value.is_value_secret
          }
        }

        dynamic "query_string" {
          for_each = invocation_http_parameters.value.query_string
          content {
            key             = query_string.value.key
            value           = query_string.value.value
            is_value_secret = query_string.value.is_value_secret
          }
        }
      }
    }
  }

  dynamic "invocation_connectivity_parameters" {
    for_each = var.invocation_connectivity_parameters != null ? [var.invocation_connectivity_parameters] : []
    content {
      resource_parameters {
        resource_configuration_arn = invocation_connectivity_parameters.value.resource_parameters.resource_configuration_arn
      }
    }
  }
}