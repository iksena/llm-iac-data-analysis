variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account" {
  description = "AWS account ID to grant access to."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account))
    error_message = "resource_aws_opensearch_authorize_vpc_endpoint_access, account must be a valid 12-digit AWS account ID."
  }
}

variable "domain_name" {
  description = "Name of OpenSearch Service domain to provide access to."
  type        = string

  validation {
    condition     = length(var.domain_name) >= 3 && length(var.domain_name) <= 28
    error_message = "resource_aws_opensearch_authorize_vpc_endpoint_access, domain_name must be between 3 and 28 characters long."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9\\-]+$", var.domain_name))
    error_message = "resource_aws_opensearch_authorize_vpc_endpoint_access, domain_name must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens."
  }
}