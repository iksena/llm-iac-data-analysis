variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_elasticsearch_domain_policy, region must be a valid AWS region format or null."
  }
}

variable "domain_name" {
  description = "Name of the domain."
  type        = string

  validation {
    condition     = length(var.domain_name) >= 3 && length(var.domain_name) <= 28
    error_message = "resource_aws_elasticsearch_domain_policy, domain_name must be between 3 and 28 characters long."
  }

  validation {
    condition     = can(regex("^[a-z][a-z0-9\\-]*[a-z0-9]$", var.domain_name))
    error_message = "resource_aws_elasticsearch_domain_policy, domain_name must start with a lowercase letter and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "access_policies" {
  description = "IAM policy document specifying the access policies for the domain"
  type        = string
  default     = null

  validation {
    condition     = var.access_policies == null || can(jsondecode(var.access_policies))
    error_message = "resource_aws_elasticsearch_domain_policy, access_policies must be a valid JSON policy document or null."
  }
}