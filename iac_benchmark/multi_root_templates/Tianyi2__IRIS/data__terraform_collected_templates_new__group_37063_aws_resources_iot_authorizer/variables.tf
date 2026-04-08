variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "authorizer_function_arn" {
  description = "The ARN of the authorizer's Lambda function."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:lambda:", var.authorizer_function_arn))
    error_message = "resource_aws_iot_authorizer, authorizer_function_arn must be a valid Lambda function ARN starting with 'arn:aws:lambda:'."
  }
}

variable "enable_caching_for_http" {
  description = "Specifies whether the HTTP caching is enabled or not."
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the authorizer."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_iot_authorizer, name cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.name))
    error_message = "resource_aws_iot_authorizer, name must contain only alphanumeric characters, underscores, and hyphens."
  }
}

variable "signing_disabled" {
  description = "Specifies whether AWS IoT validates the token signature in an authorization request."
  type        = bool
  default     = false
}

variable "status" {
  description = "The status of Authorizer request at creation. Valid values: ACTIVE, INACTIVE."
  type        = string
  default     = "ACTIVE"

  validation {
    condition     = contains(["ACTIVE", "INACTIVE"], var.status)
    error_message = "resource_aws_iot_authorizer, status must be one of: ACTIVE, INACTIVE."
  }
}

variable "tags" {
  description = "Map of tags to assign to this resource."
  type        = map(string)
  default     = {}
}

variable "token_key_name" {
  description = "The name of the token key used to extract the token from the HTTP headers. This value is required if signing is enabled in your authorizer."
  type        = string
  default     = null

  validation {
    condition     = var.token_key_name == null || length(var.token_key_name) > 0
    error_message = "resource_aws_iot_authorizer, token_key_name cannot be empty when specified."
  }
}

variable "token_signing_public_keys" {
  description = "The public keys used to verify the digital signature returned by your custom authentication service. This value is required if signing is enabled in your authorizer."
  type        = map(string)
  default     = {}
}