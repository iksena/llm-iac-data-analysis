variable "domain_name" {
  description = "Name of the domain"
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9\\-]{2,27}$", var.domain_name))
    error_message = "resource_aws_opensearch_domain_saml_options, domain_name must be between 3 and 28 characters, start with a lowercase letter, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "saml_options" {
  description = "SAML authentication options for an AWS OpenSearch Domain"
  type = object({
    enabled                 = bool
    master_backend_role     = optional(string)
    master_user_name        = optional(string)
    roles_key               = optional(string, "roles")
    session_timeout_minutes = optional(number, 60)
    subject_key             = optional(string, "NameID")
    idp = optional(object({
      entity_id        = string
      metadata_content = string
    }))
  })
  default = null

  validation {
    condition = var.saml_options == null || (
      var.saml_options.session_timeout_minutes >= 1 &&
      var.saml_options.session_timeout_minutes <= 1440
    )
    error_message = "resource_aws_opensearch_domain_saml_options, session_timeout_minutes must be between 1 and 1440 minutes."
  }

  validation {
    condition = var.saml_options == null || var.saml_options.idp == null || (
      can(regex("^https?://", var.saml_options.idp.entity_id))
    )
    error_message = "resource_aws_opensearch_domain_saml_options, entity_id must be a valid URL starting with http:// or https://."
  }

  validation {
    condition = var.saml_options == null || var.saml_options.idp == null || (
      length(var.saml_options.idp.metadata_content) > 0
    )
    error_message = "resource_aws_opensearch_domain_saml_options, metadata_content cannot be empty when idp is specified."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    update = optional(string, "180m")
    delete = optional(string, "90m")
  })
  default = {
    update = "180m"
    delete = "90m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.update))
    error_message = "resource_aws_opensearch_domain_saml_options, update timeout must be in valid duration format (e.g., '180m', '3h')."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_opensearch_domain_saml_options, delete timeout must be in valid duration format (e.g., '90m', '1h')."
  }
}