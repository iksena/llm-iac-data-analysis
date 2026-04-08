variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "The name for the connection"
  type        = string
  validation {
    condition     = can(regex("^[0-9A-Za-z._-]{1,64}$", var.name))
    error_message = "resource_aws_cloudwatch_event_connection, name must be a maximum of 64 characters consisting of numbers, lower/upper case letters, .,-,_."
  }
}

variable "description" {
  description = "Description for the connection"
  type        = string
  default     = null
  validation {
    condition     = var.description == null || length(var.description) <= 512
    error_message = "resource_aws_cloudwatch_event_connection, description must be a maximum of 512 characters."
  }
}

variable "authorization_type" {
  description = "Type of authorization to use for the connection"
  type        = string
  validation {
    condition     = contains(["API_KEY", "BASIC", "OAUTH_CLIENT_CREDENTIALS"], var.authorization_type)
    error_message = "resource_aws_cloudwatch_event_connection, authorization_type must be one of API_KEY, BASIC, or OAUTH_CLIENT_CREDENTIALS."
  }
}

variable "kms_key_identifier" {
  description = "Identifier of the AWS KMS customer managed key for EventBridge to use"
  type        = string
  default     = null
}

variable "auth_parameters_api_key" {
  description = "Parameters used for API_KEY authorization"
  type = object({
    key   = string
    value = string
  })
  default = null
  validation {
    condition = var.auth_parameters_api_key == null || (
      var.auth_parameters_api_key.key != null &&
      var.auth_parameters_api_key.value != null
    )
    error_message = "resource_aws_cloudwatch_event_connection, auth_parameters_api_key key and value are required when specified."
  }
}

variable "auth_parameters_basic" {
  description = "Parameters used for BASIC authorization"
  type = object({
    username = string
    password = string
  })
  default = null
  validation {
    condition = var.auth_parameters_basic == null || (
      var.auth_parameters_basic.username != null &&
      var.auth_parameters_basic.password != null
    )
    error_message = "resource_aws_cloudwatch_event_connection, auth_parameters_basic username and password are required when specified."
  }
}

variable "auth_parameters_oauth" {
  description = "Parameters used for OAUTH_CLIENT_CREDENTIALS authorization"
  type = object({
    authorization_endpoint = string
    http_method            = string
    client_parameters = object({
      client_id     = string
      client_secret = string
    })
    oauth_http_parameters = object({
      body = optional(list(object({
        key             = string
        value           = string
        is_value_secret = optional(bool, false)
      })), [])
      header = optional(list(object({
        key             = string
        value           = string
        is_value_secret = optional(bool, false)
      })), [])
      query_string = optional(list(object({
        key             = string
        value           = string
        is_value_secret = optional(bool, false)
      })), [])
    })
  })
  default = null
  validation {
    condition = var.auth_parameters_oauth == null || (
      var.auth_parameters_oauth.authorization_endpoint != null &&
      var.auth_parameters_oauth.http_method != null &&
      var.auth_parameters_oauth.client_parameters != null &&
      var.auth_parameters_oauth.client_parameters.client_id != null &&
      var.auth_parameters_oauth.client_parameters.client_secret != null &&
      var.auth_parameters_oauth.oauth_http_parameters != null
    )
    error_message = "resource_aws_cloudwatch_event_connection, auth_parameters_oauth authorization_endpoint, http_method, and client_parameters are required when specified."
  }
}

variable "auth_parameters_invocation_http_parameters" {
  description = "Invocation Http Parameters for additional credentials"
  type = object({
    body = optional(list(object({
      key             = string
      value           = string
      is_value_secret = optional(bool, false)
    })), [])
    header = optional(list(object({
      key             = string
      value           = string
      is_value_secret = optional(bool, false)
    })), [])
    query_string = optional(list(object({
      key             = string
      value           = string
      is_value_secret = optional(bool, false)
    })), [])
  })
  default = null
  validation {
    condition = var.auth_parameters_invocation_http_parameters == null || (
      length(concat(
        var.auth_parameters_invocation_http_parameters.body,
        var.auth_parameters_invocation_http_parameters.header,
        var.auth_parameters_invocation_http_parameters.query_string
      )) <= 100
    )
    error_message = "resource_aws_cloudwatch_event_connection, auth_parameters_invocation_http_parameters can include up to 100 additional parameters per request."
  }
}

variable "invocation_connectivity_parameters" {
  description = "Parameters to use for invoking a private API"
  type = object({
    resource_parameters = object({
      resource_configuration_arn = string
    })
  })
  default = null
  validation {
    condition = var.invocation_connectivity_parameters == null || (
      var.invocation_connectivity_parameters.resource_parameters != null &&
      var.invocation_connectivity_parameters.resource_parameters.resource_configuration_arn != null
    )
    error_message = "resource_aws_cloudwatch_event_connection, invocation_connectivity_parameters resource_parameters.resource_configuration_arn is required when specified."
  }
}