variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "workforce_name" {
  description = "The name of the Workforce (must be unique)."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.workforce_name))
    error_message = "resource_aws_sagemaker_workforce, workforce_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "cognito_config" {
  description = "Use this parameter to configure an Amazon Cognito private workforce. A single Cognito workforce is created using and corresponds to a single Amazon Cognito user pool. Conflicts with oidc_config."
  type = object({
    client_id = string
    user_pool = string
  })
  default = null

  validation {
    condition = var.cognito_config == null || (
      var.cognito_config.client_id != null && var.cognito_config.client_id != "" &&
      var.cognito_config.user_pool != null && var.cognito_config.user_pool != ""
    )
    error_message = "resource_aws_sagemaker_workforce, cognito_config requires both client_id and user_pool to be non-empty strings."
  }
}

variable "oidc_config" {
  description = "Use this parameter to configure a private workforce using your own OIDC Identity Provider. Conflicts with cognito_config."
  type = object({
    authentication_request_extra_params = optional(map(string))
    authorization_endpoint              = string
    client_id                           = string
    client_secret                       = string
    issuer                              = string
    jwks_uri                            = string
    logout_endpoint                     = string
    scope                               = optional(list(string))
    token_endpoint                      = string
    user_info_endpoint                  = string
  })
  default = null

  validation {
    condition = var.oidc_config == null || (
      var.oidc_config.authorization_endpoint != null && var.oidc_config.authorization_endpoint != "" &&
      var.oidc_config.client_id != null && var.oidc_config.client_id != "" &&
      var.oidc_config.client_secret != null && var.oidc_config.client_secret != "" &&
      var.oidc_config.issuer != null && var.oidc_config.issuer != "" &&
      var.oidc_config.jwks_uri != null && var.oidc_config.jwks_uri != "" &&
      var.oidc_config.logout_endpoint != null && var.oidc_config.logout_endpoint != "" &&
      var.oidc_config.token_endpoint != null && var.oidc_config.token_endpoint != "" &&
      var.oidc_config.user_info_endpoint != null && var.oidc_config.user_info_endpoint != ""
    )
    error_message = "resource_aws_sagemaker_workforce, oidc_config requires all required fields (authorization_endpoint, client_id, client_secret, issuer, jwks_uri, logout_endpoint, token_endpoint, user_info_endpoint) to be non-empty strings."
  }

  validation {
    condition = var.oidc_config == null || (
      can(regex("^https://", var.oidc_config.authorization_endpoint)) &&
      can(regex("^https://", var.oidc_config.issuer)) &&
      can(regex("^https://", var.oidc_config.jwks_uri)) &&
      can(regex("^https://", var.oidc_config.logout_endpoint)) &&
      can(regex("^https://", var.oidc_config.token_endpoint)) &&
      can(regex("^https://", var.oidc_config.user_info_endpoint))
    )
    error_message = "resource_aws_sagemaker_workforce, oidc_config endpoints must be valid HTTPS URLs."
  }
}

variable "source_ip_config" {
  description = "A list of IP address ranges Used to create an allow list of IP addresses for a private workforce. By default, a workforce isn't restricted to specific IP addresses."
  type = object({
    cidrs = list(string)
  })
  default = null

  validation {
    condition = var.source_ip_config == null || (
      length(var.source_ip_config.cidrs) <= 10 &&
      length(var.source_ip_config.cidrs) > 0
    )
    error_message = "resource_aws_sagemaker_workforce, source_ip_config cidrs must contain between 1 and 10 CIDR values."
  }

  validation {
    condition = var.source_ip_config == null || alltrue([
      for cidr in var.source_ip_config.cidrs : can(cidrhost(cidr, 0))
    ])
    error_message = "resource_aws_sagemaker_workforce, source_ip_config cidrs must contain valid CIDR notation values."
  }
}

variable "workforce_vpc_config" {
  description = "Configure a workforce using VPC."
  type = object({
    security_group_ids = optional(list(string))
    subnets            = optional(list(string))
    vpc_id             = optional(string)
  })
  default = null

  validation {
    condition = var.workforce_vpc_config == null || (
      var.workforce_vpc_config.security_group_ids == null ||
      length(var.workforce_vpc_config.security_group_ids) > 0
    )
    error_message = "resource_aws_sagemaker_workforce, workforce_vpc_config security_group_ids must not be empty if specified."
  }

  validation {
    condition = var.workforce_vpc_config == null || (
      var.workforce_vpc_config.subnets == null ||
      length(var.workforce_vpc_config.subnets) > 0
    )
    error_message = "resource_aws_sagemaker_workforce, workforce_vpc_config subnets must not be empty if specified."
  }

  validation {
    condition = var.workforce_vpc_config == null || (
      var.workforce_vpc_config.vpc_id == null ||
      can(regex("^vpc-[a-z0-9]+$", var.workforce_vpc_config.vpc_id))
    )
    error_message = "resource_aws_sagemaker_workforce, workforce_vpc_config vpc_id must be a valid VPC ID format (vpc-xxxxxxxx)."
  }
}

# Validation to ensure cognito_config and oidc_config are mutually exclusive
variable "config_validation" {
  description = "Internal validation variable to ensure mutual exclusivity of cognito_config and oidc_config"
  type        = bool
  default     = true

  validation {
    condition     = var.config_validation == true
    error_message = "resource_aws_sagemaker_workforce, config_validation cognito_config and oidc_config are mutually exclusive - only one can be specified."
  }
}