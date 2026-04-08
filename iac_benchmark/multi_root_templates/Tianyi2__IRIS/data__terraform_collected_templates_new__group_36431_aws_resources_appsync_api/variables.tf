variable "name" {
  description = "Name of the Event API."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_appsync_api, name must not be empty."
  }
}

variable "owner_contact" {
  description = "Contact information for the owner of the Event API."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "event_config" {
  description = "Configuration for the Event API."
  type = object({
    auth_provider = object({
      auth_type = string
      cognito_config = optional(object({
        app_id_client_regex = optional(string)
        aws_region          = string
        user_pool_id        = string
      }))
      lambda_authorizer_config = optional(object({
        authorizer_result_ttl_in_seconds = optional(number)
        authorizer_uri                   = string
        identity_validation_expression   = optional(string)
      }))
      openid_connect_config = optional(object({
        auth_ttl  = optional(number)
        client_id = optional(string)
        iat_ttl   = optional(number)
        issuer    = string
      }))
    })
    connection_auth_mode = object({
      auth_type = string
    })
    default_publish_auth_mode = object({
      auth_type = string
    })
    default_subscribe_auth_mode = object({
      auth_type = string
    })
    log_config = optional(object({
      cloudwatch_logs_role_arn = string
      log_level                = string
    }))
  })

  validation {
    condition = contains([
      "API_KEY",
      "AWS_IAM",
      "AMAZON_COGNITO_USER_POOLS",
      "OPENID_CONNECT",
      "AWS_LAMBDA"
    ], var.event_config.auth_provider.auth_type)
    error_message = "resource_aws_appsync_api, auth_provider.auth_type must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }

  validation {
    condition = contains([
      "API_KEY",
      "AWS_IAM",
      "AMAZON_COGNITO_USER_POOLS",
      "OPENID_CONNECT",
      "AWS_LAMBDA"
    ], var.event_config.connection_auth_mode.auth_type)
    error_message = "resource_aws_appsync_api, connection_auth_mode.auth_type must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }

  validation {
    condition = contains([
      "API_KEY",
      "AWS_IAM",
      "AMAZON_COGNITO_USER_POOLS",
      "OPENID_CONNECT",
      "AWS_LAMBDA"
    ], var.event_config.default_publish_auth_mode.auth_type)
    error_message = "resource_aws_appsync_api, default_publish_auth_mode.auth_type must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }

  validation {
    condition = contains([
      "API_KEY",
      "AWS_IAM",
      "AMAZON_COGNITO_USER_POOLS",
      "OPENID_CONNECT",
      "AWS_LAMBDA"
    ], var.event_config.default_subscribe_auth_mode.auth_type)
    error_message = "resource_aws_appsync_api, default_subscribe_auth_mode.auth_type must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }

  validation {
    condition     = var.event_config.auth_provider.auth_type == "AMAZON_COGNITO_USER_POOLS" ? var.event_config.auth_provider.cognito_config != null : true
    error_message = "resource_aws_appsync_api, cognito_config is required when auth_provider.auth_type is AMAZON_COGNITO_USER_POOLS."
  }

  validation {
    condition     = var.event_config.auth_provider.auth_type == "AWS_LAMBDA" ? var.event_config.auth_provider.lambda_authorizer_config != null : true
    error_message = "resource_aws_appsync_api, lambda_authorizer_config is required when auth_provider.auth_type is AWS_LAMBDA."
  }

  validation {
    condition     = var.event_config.auth_provider.auth_type == "OPENID_CONNECT" ? var.event_config.auth_provider.openid_connect_config != null : true
    error_message = "resource_aws_appsync_api, openid_connect_config is required when auth_provider.auth_type is OPENID_CONNECT."
  }

  validation {
    condition     = var.event_config.auth_provider.cognito_config != null ? length(var.event_config.auth_provider.cognito_config.aws_region) > 0 : true
    error_message = "resource_aws_appsync_api, cognito_config.aws_region must not be empty when cognito_config is provided."
  }

  validation {
    condition     = var.event_config.auth_provider.cognito_config != null ? length(var.event_config.auth_provider.cognito_config.user_pool_id) > 0 : true
    error_message = "resource_aws_appsync_api, cognito_config.user_pool_id must not be empty when cognito_config is provided."
  }

  validation {
    condition     = var.event_config.auth_provider.lambda_authorizer_config != null ? length(var.event_config.auth_provider.lambda_authorizer_config.authorizer_uri) > 0 : true
    error_message = "resource_aws_appsync_api, lambda_authorizer_config.authorizer_uri must not be empty when lambda_authorizer_config is provided."
  }

  validation {
    condition     = var.event_config.auth_provider.openid_connect_config != null ? length(var.event_config.auth_provider.openid_connect_config.issuer) > 0 : true
    error_message = "resource_aws_appsync_api, openid_connect_config.issuer must not be empty when openid_connect_config is provided."
  }

  validation {
    condition = var.event_config.log_config != null ? contains([
      "NONE",
      "ERROR",
      "ALL",
      "INFO",
      "DEBUG"
    ], var.event_config.log_config.log_level) : true
    error_message = "resource_aws_appsync_api, log_config.log_level must be one of: NONE, ERROR, ALL, INFO, DEBUG."
  }

  validation {
    condition     = var.event_config.log_config != null ? length(var.event_config.log_config.cloudwatch_logs_role_arn) > 0 : true
    error_message = "resource_aws_appsync_api, log_config.cloudwatch_logs_role_arn must not be empty when log_config is provided."
  }
}