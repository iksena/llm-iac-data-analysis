variable "domain_name" {
  description = "Name of the domain"
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_elasticsearch_domain_saml_options, domain_name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "saml_options" {
  description = "The SAML authentication options for an AWS Elasticsearch Domain"
  type = object({
    enabled                 = bool
    master_backend_role     = optional(string)
    master_user_name        = optional(string)
    roles_key               = optional(string, "roles")
    session_timeout_minutes = optional(number, 60)
    subject_key             = optional(string, "")
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
    error_message = "resource_aws_elasticsearch_domain_saml_options, session_timeout_minutes must be between 1 and 1440 minutes."
  }

  validation {
    condition = var.saml_options == null || var.saml_options.idp == null || (
      length(var.saml_options.idp.entity_id) > 0 &&
      length(var.saml_options.idp.metadata_content) > 0
    )
    error_message = "resource_aws_elasticsearch_domain_saml_options, idp entity_id and metadata_content must be non-empty strings when idp is specified."
  }
}