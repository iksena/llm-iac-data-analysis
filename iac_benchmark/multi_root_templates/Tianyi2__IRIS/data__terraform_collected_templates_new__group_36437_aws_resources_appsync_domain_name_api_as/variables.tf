variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "api_id" {
  description = "API ID."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9]+$", var.api_id))
    error_message = "resource_aws_appsync_domain_name_api_association, api_id must contain only lowercase alphanumeric characters."
  }
}

variable "domain_name" {
  description = "Appsync domain name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9.-]+$", var.domain_name))
    error_message = "resource_aws_appsync_domain_name_api_association, domain_name must be a valid domain name format."
  }
}