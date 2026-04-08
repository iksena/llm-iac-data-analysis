variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "user_pool_id" {
  description = "The user pool ID."
  type        = string

  validation {
    condition     = can(regex("^[\\w-]+$", var.user_pool_id))
    error_message = "resource_aws_cognito_risk_configuration, user_pool_id must be a valid user pool ID."
  }
}

variable "client_id" {
  description = "The app client ID. When the client ID is not provided, the same risk configuration is applied to all the clients in the User Pool."
  type        = string
  default     = null
}

variable "account_takeover_risk_configuration" {
  description = "The account takeover risk configuration."
  type = object({
    notify_configuration = object({
      from       = optional(string)
      reply_to   = optional(string)
      source_arn = string
      block_email = optional(object({
        html_body = string
        subject   = string
        text_body = string
      }))
      mfa_email = optional(object({
        html_body = string
        subject   = string
        text_body = string
      }))
      no_action_email = optional(object({
        html_body = string
        subject   = string
        text_body = string
      }))
    })
    actions = object({
      high_action = optional(object({
        event_action = string
        notify       = bool
      }))
      low_action = optional(object({
        event_action = string
        notify       = bool
      }))
      medium_action = optional(object({
        event_action = string
        notify       = bool
      }))
    })
  })
  default = null

  validation {
    condition = var.account_takeover_risk_configuration == null || (
      var.account_takeover_risk_configuration.notify_configuration != null &&
      var.account_takeover_risk_configuration.actions != null
    )
    error_message = "resource_aws_cognito_risk_configuration, account_takeover_risk_configuration notify_configuration and actions are required when account_takeover_risk_configuration is specified."
  }

  validation {
    condition = var.account_takeover_risk_configuration == null || (
      var.account_takeover_risk_configuration.notify_configuration.source_arn != null &&
      can(regex("^arn:aws[a-z\\-]*:ses:", var.account_takeover_risk_configuration.notify_configuration.source_arn))
    )
    error_message = "resource_aws_cognito_risk_configuration, account_takeover_risk_configuration notify_configuration source_arn must be a valid SES ARN."
  }

  validation {
    condition = var.account_takeover_risk_configuration == null || (
      var.account_takeover_risk_configuration.actions.high_action == null ||
      contains(["BLOCK", "MFA_IF_CONFIGURED", "MFA_REQUIRED", "NO_ACTION"], var.account_takeover_risk_configuration.actions.high_action.event_action)
    )
    error_message = "resource_aws_cognito_risk_configuration, account_takeover_risk_configuration actions high_action event_action must be one of: BLOCK, MFA_IF_CONFIGURED, MFA_REQUIRED, NO_ACTION."
  }

  validation {
    condition = var.account_takeover_risk_configuration == null || (
      var.account_takeover_risk_configuration.actions.low_action == null ||
      contains(["BLOCK", "MFA_IF_CONFIGURED", "MFA_REQUIRED", "NO_ACTION"], var.account_takeover_risk_configuration.actions.low_action.event_action)
    )
    error_message = "resource_aws_cognito_risk_configuration, account_takeover_risk_configuration actions low_action event_action must be one of: BLOCK, MFA_IF_CONFIGURED, MFA_REQUIRED, NO_ACTION."
  }

  validation {
    condition = var.account_takeover_risk_configuration == null || (
      var.account_takeover_risk_configuration.actions.medium_action == null ||
      contains(["BLOCK", "MFA_IF_CONFIGURED", "MFA_REQUIRED", "NO_ACTION"], var.account_takeover_risk_configuration.actions.medium_action.event_action)
    )
    error_message = "resource_aws_cognito_risk_configuration, account_takeover_risk_configuration actions medium_action event_action must be one of: BLOCK, MFA_IF_CONFIGURED, MFA_REQUIRED, NO_ACTION."
  }
}

variable "compromised_credentials_risk_configuration" {
  description = "The compromised credentials risk configuration."
  type = object({
    event_filter = optional(list(string))
    actions = object({
      event_action = optional(string)
    })
  })
  default = null

  validation {
    condition = var.compromised_credentials_risk_configuration == null || (
      var.compromised_credentials_risk_configuration.actions != null
    )
    error_message = "resource_aws_cognito_risk_configuration, compromised_credentials_risk_configuration actions is required when compromised_credentials_risk_configuration is specified."
  }

  validation {
    condition = var.compromised_credentials_risk_configuration == null || (
      var.compromised_credentials_risk_configuration.event_filter == null ||
      alltrue([for event in var.compromised_credentials_risk_configuration.event_filter : contains(["SIGN_IN", "PASSWORD_CHANGE", "SIGN_UP"], event)])
    )
    error_message = "resource_aws_cognito_risk_configuration, compromised_credentials_risk_configuration event_filter values must be one of: SIGN_IN, PASSWORD_CHANGE, SIGN_UP."
  }

  validation {
    condition = var.compromised_credentials_risk_configuration == null || (
      var.compromised_credentials_risk_configuration.actions.event_action == null ||
      contains(["BLOCK", "NO_ACTION"], var.compromised_credentials_risk_configuration.actions.event_action)
    )
    error_message = "resource_aws_cognito_risk_configuration, compromised_credentials_risk_configuration actions event_action must be one of: BLOCK, NO_ACTION."
  }
}

variable "risk_exception_configuration" {
  description = "The configuration to override the risk decision."
  type = object({
    blocked_ip_range_list = optional(list(string))
    skipped_ip_range_list = optional(list(string))
  })
  default = null

  validation {
    condition = var.risk_exception_configuration == null || (
      var.risk_exception_configuration.blocked_ip_range_list == null ||
      length(var.risk_exception_configuration.blocked_ip_range_list) <= 200
    )
    error_message = "resource_aws_cognito_risk_configuration, risk_exception_configuration blocked_ip_range_list can contain a maximum of 200 items."
  }

  validation {
    condition = var.risk_exception_configuration == null || (
      var.risk_exception_configuration.skipped_ip_range_list == null ||
      length(var.risk_exception_configuration.skipped_ip_range_list) <= 200
    )
    error_message = "resource_aws_cognito_risk_configuration, risk_exception_configuration skipped_ip_range_list can contain a maximum of 200 items."
  }

  validation {
    condition = var.risk_exception_configuration == null || (
      var.risk_exception_configuration.blocked_ip_range_list == null ||
      alltrue([for ip in var.risk_exception_configuration.blocked_ip_range_list : can(cidrhost(ip, 0))])
    )
    error_message = "resource_aws_cognito_risk_configuration, risk_exception_configuration blocked_ip_range_list must contain valid CIDR notation."
  }

  validation {
    condition = var.risk_exception_configuration == null || (
      var.risk_exception_configuration.skipped_ip_range_list == null ||
      alltrue([for ip in var.risk_exception_configuration.skipped_ip_range_list : can(cidrhost(ip, 0))])
    )
    error_message = "resource_aws_cognito_risk_configuration, risk_exception_configuration skipped_ip_range_list must contain valid CIDR notation."
  }
}