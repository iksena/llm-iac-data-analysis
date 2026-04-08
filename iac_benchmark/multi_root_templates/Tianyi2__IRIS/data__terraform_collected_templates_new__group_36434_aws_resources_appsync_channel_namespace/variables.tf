variable "api_id" {
  description = "Event API ID"
  type        = string

  validation {
    condition     = length(var.api_id) > 0
    error_message = "resource_aws_appsync_channel_namespace, api_id must not be empty."
  }
}

variable "name" {
  description = "Name of the channel namespace"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_appsync_channel_namespace, name must not be empty."
  }
}

variable "code_handlers" {
  description = "Event handler functions that run custom business logic to process published events and subscribe requests"
  type        = string
  default     = null
}

variable "handler_configs" {
  description = "Configuration for the on_publish and on_subscribe handlers"
  type = object({
    on_publish = optional(object({
      behavior = string
      integration = object({
        data_source_name = string
        lambda_config = optional(object({
          invoke_type = optional(string)
        }))
      })
    }))
    on_subscribe = optional(object({
      behavior = string
      integration = object({
        data_source_name = string
        lambda_config = optional(object({
          invoke_type = optional(string)
        }))
      })
    }))
  })
  default = null

  validation {
    condition = var.handler_configs == null || (
      var.handler_configs.on_publish == null || contains(["CODE", "DIRECT"], var.handler_configs.on_publish.behavior)
    )
    error_message = "resource_aws_appsync_channel_namespace, handler_configs.on_publish.behavior must be one of: CODE, DIRECT."
  }

  validation {
    condition = var.handler_configs == null || (
      var.handler_configs.on_subscribe == null || contains(["CODE", "DIRECT"], var.handler_configs.on_subscribe.behavior)
    )
    error_message = "resource_aws_appsync_channel_namespace, handler_configs.on_subscribe.behavior must be one of: CODE, DIRECT."
  }

  validation {
    condition = var.handler_configs == null || (
      var.handler_configs.on_publish == null ||
      var.handler_configs.on_publish.integration.lambda_config == null ||
      var.handler_configs.on_publish.integration.lambda_config.invoke_type == null ||
      contains(["REQUEST_RESPONSE", "EVENT"], var.handler_configs.on_publish.integration.lambda_config.invoke_type)
    )
    error_message = "resource_aws_appsync_channel_namespace, handler_configs.on_publish.integration.lambda_config.invoke_type must be one of: REQUEST_RESPONSE, EVENT."
  }

  validation {
    condition = var.handler_configs == null || (
      var.handler_configs.on_subscribe == null ||
      var.handler_configs.on_subscribe.integration.lambda_config == null ||
      var.handler_configs.on_subscribe.integration.lambda_config.invoke_type == null ||
      contains(["REQUEST_RESPONSE", "EVENT"], var.handler_configs.on_subscribe.integration.lambda_config.invoke_type)
    )
    error_message = "resource_aws_appsync_channel_namespace, handler_configs.on_subscribe.integration.lambda_config.invoke_type must be one of: REQUEST_RESPONSE, EVENT."
  }

  validation {
    condition = var.handler_configs == null || (
      var.handler_configs.on_publish == null ||
      length(var.handler_configs.on_publish.integration.data_source_name) > 0
    )
    error_message = "resource_aws_appsync_channel_namespace, handler_configs.on_publish.integration.data_source_name must not be empty."
  }

  validation {
    condition = var.handler_configs == null || (
      var.handler_configs.on_subscribe == null ||
      length(var.handler_configs.on_subscribe.integration.data_source_name) > 0
    )
    error_message = "resource_aws_appsync_channel_namespace, handler_configs.on_subscribe.integration.data_source_name must not be empty."
  }
}

variable "publish_auth_mode" {
  description = "Authorization modes to use for publishing messages on the channel namespace"
  type = object({
    auth_type = string
  })
  default = null

  validation {
    condition = var.publish_auth_mode == null || contains([
      "API_KEY", "AWS_IAM", "AMAZON_COGNITO_USER_POOLS", "OPENID_CONNECT", "AWS_LAMBDA"
    ], var.publish_auth_mode.auth_type)
    error_message = "resource_aws_appsync_channel_namespace, publish_auth_mode.auth_type must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }
}

variable "subscribe_auth_mode" {
  description = "Authorization modes to use for subscribing to messages on the channel namespace"
  type = object({
    auth_type = string
  })
  default = null

  validation {
    condition = var.subscribe_auth_mode == null || contains([
      "API_KEY", "AWS_IAM", "AMAZON_COGNITO_USER_POOLS", "OPENID_CONNECT", "AWS_LAMBDA"
    ], var.subscribe_auth_mode.auth_type)
    error_message = "resource_aws_appsync_channel_namespace, subscribe_auth_mode.auth_type must be one of: API_KEY, AWS_IAM, AMAZON_COGNITO_USER_POOLS, OPENID_CONNECT, AWS_LAMBDA."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = null
}