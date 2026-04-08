variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_identifier" {
  description = "The ID or Amazon Resource Name (ARN) of the service network or service for which the policy is created."
  type        = string

  validation {
    condition     = length(var.resource_identifier) > 0
    error_message = "resource_aws_vpclattice_auth_policy, resource_identifier must not be empty."
  }
}

variable "policy" {
  description = "The auth policy. The policy string in JSON must not contain newlines or blank lines."
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_vpclattice_auth_policy, policy must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_vpclattice_auth_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = !can(regex("\\n|\\r", var.policy))
    error_message = "resource_aws_vpclattice_auth_policy, policy must not contain newlines or blank lines."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = null
}