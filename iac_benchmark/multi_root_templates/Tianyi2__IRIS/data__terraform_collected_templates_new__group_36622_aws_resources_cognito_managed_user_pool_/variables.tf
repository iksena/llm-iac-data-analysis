variable "user_pool_id" {
  description = "User pool that the client belongs to."
  type        = string
}

variable "name_pattern" {
  description = "Regular expression that matches the name of the existing User Pool Client to be managed. It must only match one User Pool Client."
  type        = string
  default     = null

  validation {
    condition     = var.name_pattern != null ? can(regex("^.*$", var.name_pattern)) : true
    error_message = "resource_aws_cognito_managed_user_pool_client, name_pattern must be a valid regular expression."
  }
}

variable "name_prefix" {
  description = "String that matches the beginning of the name of the existing User Pool Client to be managed. It must match only one User Pool Client."
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "access_token_validity" {
  description = "Time limit, between 5 minutes and 1 day, after which the access token is no longer valid and cannot be used. By default, the unit is hours. The unit can be overridden by a value in token_validity_units.access_token."
  type        = number
  default     = null

  validation {
    condition = var.access_token_validity == null ? true : (
      var.access_token_validity >= 5 && var.access_token_validity <= 1440
    )
    error_message = "resource_aws_cognito_managed_user_pool_client, access_token_validity must be between 5 minutes and 1 day (1440 minutes)."
  }
}

variable "allowed_oauth_flows_user_pool_client" {
  description = "Whether the client is allowed to use OAuth 2.0 features. allowed_oauth_flows_user_pool_client must be set to true before you can configure the following arguments: callback_urls, logout_urls, allowed_oauth_scopes and allowed_oauth_flows."
  type        = bool
  default     = null
}

variable "allowed_oauth_flows" {
  description = "List of allowed OAuth flows, including code, implicit, and client_credentials. allowed_oauth_flows_user_pool_client must be set to true before you can configure this option."
  type        = list(string)
  default     = null

  validation {
    condition = var.allowed_oauth_flows == null ? true : alltrue([
      for flow in var.allowed_oauth_flows : contains(["code", "implicit", "client_credentials"], flow)
    ])
    error_message = "resource_aws_cognito_managed_user_pool_client, allowed_oauth_flows must contain only valid OAuth flows: code, implicit, client_credentials."
  }
}

variable "allowed_oauth_scopes" {
  description = "List of allowed OAuth scopes, including phone, email, openid, profile, and aws.cognito.signin.user.admin. allowed_oauth_flows_user_pool_client must be set to true before you can configure this option."
  type        = list(string)
  default     = null

  validation {
    condition = var.allowed_oauth_scopes == null ? true : alltrue([
      for scope in var.allowed_oauth_scopes : contains(["phone", "email", "openid", "profile", "aws.cognito.signin.user.admin"], scope)
    ])
    error_message = "resource_aws_cognito_managed_user_pool_client, allowed_oauth_scopes must contain only valid OAuth scopes: phone, email, openid, profile, aws.cognito.signin.user.admin."
  }
}

variable "analytics_configuration" {
  description = "Configuration block for Amazon Pinpoint analytics that collects metrics for this user pool."
  type = object({
    application_arn  = optional(string)
    application_id   = optional(string)
    external_id      = optional(string)
    role_arn         = optional(string)
    user_data_shared = optional(bool)
  })
  default = null

  validation {
    condition = var.analytics_configuration == null ? true : (
      (var.analytics_configuration.application_arn != null || var.analytics_configuration.application_id != null) &&
      !(var.analytics_configuration.application_arn != null && (var.analytics_configuration.external_id != null || var.analytics_configuration.role_arn != null))
    )
    error_message = "resource_aws_cognito_managed_user_pool_client, analytics_configuration requires either application_arn or application_id, and application_arn conflicts with external_id and role_arn."
  }
}

variable "auth_session_validity" {
  description = "Duration, in minutes, of the session token created by Amazon Cognito for each API request in an authentication flow. The session token must be responded to by the native user of the user pool before it expires. Valid values for auth_session_validity are between 3 and 15, with a default value of 3."
  type        = number
  default     = null

  validation {
    condition     = var.auth_session_validity == null ? true : (var.auth_session_validity >= 3 && var.auth_session_validity <= 15)
    error_message = "resource_aws_cognito_managed_user_pool_client, auth_session_validity must be between 3 and 15 minutes."
  }
}

variable "callback_urls" {
  description = "List of allowed callback URLs for the identity providers. allowed_oauth_flows_user_pool_client must be set to true before you can configure this option."
  type        = list(string)
  default     = null
}

variable "default_redirect_uri" {
  description = "Default redirect URI and must be included in the list of callback URLs."
  type        = string
  default     = null
}

variable "enable_token_revocation" {
  description = "Enables or disables token revocation."
  type        = bool
  default     = null
}

variable "enable_propagate_additional_user_context_data" {
  description = "Enables the propagation of additional user context data."
  type        = bool
  default     = null
}

variable "explicit_auth_flows" {
  description = "List of authentication flows. The available options include ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH, ALLOW_ADMIN_USER_PASSWORD_AUTH, ALLOW_CUSTOM_AUTH, ALLOW_USER_PASSWORD_AUTH, ALLOW_USER_SRP_AUTH, and ALLOW_REFRESH_TOKEN_AUTH."
  type        = list(string)
  default     = null

  validation {
    condition = var.explicit_auth_flows == null ? true : alltrue([
      for flow in var.explicit_auth_flows : contains([
        "ADMIN_NO_SRP_AUTH",
        "CUSTOM_AUTH_FLOW_ONLY",
        "USER_PASSWORD_AUTH",
        "ALLOW_ADMIN_USER_PASSWORD_AUTH",
        "ALLOW_CUSTOM_AUTH",
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_USER_SRP_AUTH",
        "ALLOW_REFRESH_TOKEN_AUTH"
      ], flow)
    ])
    error_message = "resource_aws_cognito_managed_user_pool_client, explicit_auth_flows must contain only valid authentication flows: ADMIN_NO_SRP_AUTH, CUSTOM_AUTH_FLOW_ONLY, USER_PASSWORD_AUTH, ALLOW_ADMIN_USER_PASSWORD_AUTH, ALLOW_CUSTOM_AUTH, ALLOW_USER_PASSWORD_AUTH, ALLOW_USER_SRP_AUTH, ALLOW_REFRESH_TOKEN_AUTH."
  }
}


variable "id_token_validity" {
  description = "Time limit, between 5 minutes and 1 day, after which the ID token is no longer valid and cannot be used. By default, the unit is hours. The unit can be overridden by a value in token_validity_units.id_token."
  type        = number
  default     = null

  validation {
    condition = var.id_token_validity == null ? true : (
      var.id_token_validity >= 5 && var.id_token_validity <= 1440
    )
    error_message = "resource_aws_cognito_managed_user_pool_client, id_token_validity must be between 5 minutes and 1 day (1440 minutes)."
  }
}

variable "logout_urls" {
  description = "List of allowed logout URLs for the identity providers. allowed_oauth_flows_user_pool_client must be set to true before you can configure this option."
  type        = list(string)
  default     = null
}

variable "prevent_user_existence_errors" {
  description = "Setting determines the errors and responses returned by Cognito APIs when a user does not exist in the user pool during authentication, account confirmation, and password recovery."
  type        = string
  default     = null

  validation {
    condition     = var.prevent_user_existence_errors == null ? true : contains(["LEGACY", "ENABLED"], var.prevent_user_existence_errors)
    error_message = "resource_aws_cognito_managed_user_pool_client, prevent_user_existence_errors must be either LEGACY or ENABLED."
  }
}

variable "read_attributes" {
  description = "List of user pool attributes that the application client can read from."
  type        = list(string)
  default     = null
}

variable "refresh_token_rotation" {
  description = "A block that specifies the configuration of refresh token rotation."
  type = object({
    feature                    = string
    retry_grace_period_seconds = optional(number)
  })
  default = null

  validation {
    condition     = var.refresh_token_rotation == null ? true : contains(["ENABLED", "DISABLED"], var.refresh_token_rotation.feature)
    error_message = "resource_aws_cognito_managed_user_pool_client, refresh_token_rotation feature must be either ENABLED or DISABLED."
  }

  validation {
    condition = var.refresh_token_rotation == null ? true : (
      var.refresh_token_rotation.retry_grace_period_seconds == null ? true :
      (var.refresh_token_rotation.retry_grace_period_seconds >= 0 && var.refresh_token_rotation.retry_grace_period_seconds <= 60)
    )
    error_message = "resource_aws_cognito_managed_user_pool_client, refresh_token_rotation retry_grace_period_seconds must be between 0 and 60."
  }
}

variable "refresh_token_validity" {
  description = "Time limit, between 60 minutes and 10 years, after which the refresh token is no longer valid and cannot be used. By default, the unit is days. The unit can be overridden by a value in token_validity_units.refresh_token."
  type        = number
  default     = null

  validation {
    condition = var.refresh_token_validity == null ? true : (
      var.refresh_token_validity >= 60 && var.refresh_token_validity <= 3650
    )
    error_message = "resource_aws_cognito_managed_user_pool_client, refresh_token_validity must be between 60 minutes and 10 years (3650 days)."
  }
}

variable "supported_identity_providers" {
  description = "List of provider names for the identity providers that are supported on this client. It uses the provider_name attribute of the aws_cognito_identity_provider resource(s), or the equivalent string(s)."
  type        = list(string)
  default     = null
}

variable "token_validity_units" {
  description = "Configuration block for representing the validity times in units."
  type = object({
    access_token  = optional(string)
    id_token      = optional(string)
    refresh_token = optional(string)
  })
  default = null

  validation {
    condition = var.token_validity_units == null ? true : (
      (var.token_validity_units.access_token == null ? true : contains(["seconds", "minutes", "hours", "days"], var.token_validity_units.access_token)) &&
      (var.token_validity_units.id_token == null ? true : contains(["seconds", "minutes", "hours", "days"], var.token_validity_units.id_token)) &&
      (var.token_validity_units.refresh_token == null ? true : contains(["seconds", "minutes", "hours", "days"], var.token_validity_units.refresh_token))
    )
    error_message = "resource_aws_cognito_managed_user_pool_client, token_validity_units values must be one of: seconds, minutes, hours, days."
  }
}

variable "write_attributes" {
  description = "List of user pool attributes that the application client can write to."
  type        = list(string)
  default     = null
}