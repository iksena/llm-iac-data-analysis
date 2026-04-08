variable "access_policy" {
  description = "The access rules you want to configure. These rules replace any existing rules."
  type        = string

  validation {
    condition     = var.access_policy != ""
    error_message = "resource_aws_cloudsearch_domain_service_access_policy, access_policy cannot be empty."
  }
}

variable "domain_name" {
  description = "The CloudSearch domain name the policy applies to."
  type        = string

  validation {
    condition     = var.domain_name != ""
    error_message = "resource_aws_cloudsearch_domain_service_access_policy, domain_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "timeout_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_update))
    error_message = "resource_aws_cloudsearch_domain_service_access_policy, timeout_update must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}

variable "timeout_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_delete))
    error_message = "resource_aws_cloudsearch_domain_service_access_policy, timeout_delete must be a valid duration (e.g., '20m', '1h', '30s')."
  }
}