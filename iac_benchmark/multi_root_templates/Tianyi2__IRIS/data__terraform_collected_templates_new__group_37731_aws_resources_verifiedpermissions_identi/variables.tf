variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "policy_store_id" {
  description = "Specifies the ID of the policy store in which you want to store this identity source."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]+$", var.policy_store_id))
    error_message = "resource_aws_verifiedpermissions_identity_source, policy_store_id must contain only alphanumeric characters and hyphens."
  }
}

variable "configuration" {
  description = "Specifies the details required to communicate with the identity provider (IdP) associated with this identity source."
  type = object({
    cognito_user_pool_configuration = optional(object({
      user_pool_arn = string
      client_ids    = optional(list(string))
      group_configuration = optional(object({
        group_entity_type = string
      }))
    }))
    open_id_connect_configuration = optional(object({
      issuer           = string
      entity_id_prefix = optional(string)
      token_selection = object({
        access_token_only = optional(object({
          audiences          = optional(list(string))
          principal_id_claim = optional(string)
        }))
        identity_token_only = optional(object({
          client_ids = optional(list(string))
        }))
      })
      group_configuration = optional(object({
        group_claim       = string
        group_entity_type = string
      }))
    }))
  })

  validation {
    condition = (
      var.configuration.cognito_user_pool_configuration != null && var.configuration.open_id_connect_configuration == null
      ) || (
      var.configuration.cognito_user_pool_configuration == null && var.configuration.open_id_connect_configuration != null
    )
    error_message = "resource_aws_verifiedpermissions_identity_source, configuration must specify either cognito_user_pool_configuration or open_id_connect_configuration, but not both."
  }

  validation {
    condition     = var.configuration.cognito_user_pool_configuration == null || can(regex("^arn:aws:cognito-idp:", var.configuration.cognito_user_pool_configuration.user_pool_arn))
    error_message = "resource_aws_verifiedpermissions_identity_source, configuration.cognito_user_pool_configuration.user_pool_arn must be a valid Amazon Cognito user pool ARN."
  }

  validation {
    condition     = var.configuration.cognito_user_pool_configuration == null || var.configuration.cognito_user_pool_configuration.group_configuration == null || length(var.configuration.cognito_user_pool_configuration.group_configuration.group_entity_type) > 0
    error_message = "resource_aws_verifiedpermissions_identity_source, configuration.cognito_user_pool_configuration.group_configuration.group_entity_type cannot be empty when specified."
  }

  validation {
    condition     = var.configuration.open_id_connect_configuration == null || can(regex("^https://", var.configuration.open_id_connect_configuration.issuer))
    error_message = "resource_aws_verifiedpermissions_identity_source, configuration.open_id_connect_configuration.issuer must be a valid HTTPS URL."
  }

  validation {
    condition     = var.configuration.open_id_connect_configuration == null || var.configuration.open_id_connect_configuration.token_selection.access_token_only != null || var.configuration.open_id_connect_configuration.token_selection.identity_token_only != null
    error_message = "resource_aws_verifiedpermissions_identity_source, configuration.open_id_connect_configuration.token_selection must specify either access_token_only or identity_token_only."
  }

  validation {
    condition     = var.configuration.open_id_connect_configuration == null || var.configuration.open_id_connect_configuration.group_configuration == null || length(var.configuration.open_id_connect_configuration.group_configuration.group_claim) > 0
    error_message = "resource_aws_verifiedpermissions_identity_source, configuration.open_id_connect_configuration.group_configuration.group_claim cannot be empty when specified."
  }

  validation {
    condition     = var.configuration.open_id_connect_configuration == null || var.configuration.open_id_connect_configuration.group_configuration == null || length(var.configuration.open_id_connect_configuration.group_configuration.group_entity_type) > 0
    error_message = "resource_aws_verifiedpermissions_identity_source, configuration.open_id_connect_configuration.group_configuration.group_entity_type cannot be empty when specified."
  }
}

variable "principal_entity_type" {
  description = "Specifies the namespace and data type of the principals generated for identities authenticated by the new identity source."
  type        = string
  default     = null

  validation {
    condition     = var.principal_entity_type == null || can(regex("^[a-zA-Z][a-zA-Z0-9]*::[a-zA-Z][a-zA-Z0-9]*$", var.principal_entity_type))
    error_message = "resource_aws_verifiedpermissions_identity_source, principal_entity_type must follow the format 'Namespace::EntityType' when specified."
  }
}