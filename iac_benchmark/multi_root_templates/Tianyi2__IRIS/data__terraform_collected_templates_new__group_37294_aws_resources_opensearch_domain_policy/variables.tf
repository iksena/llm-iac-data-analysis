variable "domain_name" {
  description = "Name of the domain"
  type        = string

  validation {
    condition     = length(var.domain_name) > 0
    error_message = "resource_aws_opensearch_domain_policy, domain_name must not be empty."
  }
}

variable "access_policies" {
  description = "IAM policy document specifying the access policies for the domain"
  type        = string
  default     = null

  validation {
    condition     = var.access_policies == null || can(jsondecode(var.access_policies))
    error_message = "resource_aws_opensearch_domain_policy, access_policies must be a valid JSON string when provided."
  }
}

variable "timeouts_update" {
  description = "Timeout for update operations"
  type        = string
  default     = "180m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_update))
    error_message = "resource_aws_opensearch_domain_policy, timeouts_update must be a valid timeout format (e.g., '180m', '10s', '2h')."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operations"
  type        = string
  default     = "90m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_delete))
    error_message = "resource_aws_opensearch_domain_policy, timeouts_delete must be a valid timeout format (e.g., '90m', '10s', '2h')."
  }
}