variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "app_bundle_arn" {
  description = "The Amazon Resource Name (ARN) of the app bundle to use for the request."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:appfabric:[^:]+:[^:]+:appbundle/[a-zA-Z0-9-]+$", var.app_bundle_arn))
    error_message = "resource_aws_appfabric_app_authorization_connection, app_bundle_arn must be a valid AppFabric app bundle ARN."
  }
}

variable "app_authorization_arn" {
  description = "The Amazon Resource Name (ARN) or Universal Unique Identifier (UUID) of the app authorization to use for the request."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:appfabric:[^:]+:[^:]+:appauthorization/[a-zA-Z0-9-]+/[a-zA-Z0-9-]+$", var.app_authorization_arn)) || can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.app_authorization_arn))
    error_message = "resource_aws_appfabric_app_authorization_connection, app_authorization_arn must be a valid AppFabric app authorization ARN or UUID."
  }
}

variable "auth_request" {
  description = "Contains OAuth2 authorization information. This is required if the app authorization for the request is configured with an OAuth2 (oauth2) authorization type."
  type = object({
    code         = string
    redirect_uri = optional(string)
  })
  default = null

  validation {
    condition     = var.auth_request == null || (var.auth_request != null && var.auth_request.code != null && var.auth_request.code != "")
    error_message = "resource_aws_appfabric_app_authorization_connection, auth_request code is required when auth_request is specified."
  }
}

variable "timeouts" {
  description = "Configuration block for operation timeouts."
  type = object({
    create = optional(string, "30m")
  })
  default = {
    create = "30m"
  }

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts.create))
    error_message = "resource_aws_appfabric_app_authorization_connection, timeouts create must be a valid duration string (e.g., '30m', '1h', '120s')."
  }
}