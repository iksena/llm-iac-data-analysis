variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}[a-z]{1}$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^cn-[a-z]+-[0-9]{1}$", var.region))
    error_message = "resource_aws_ecr_registry_policy, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null to use provider default."
  }
}

variable "policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_ecr_registry_policy, policy must be a valid JSON string."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_ecr_registry_policy, policy cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy)) ? contains(keys(jsondecode(var.policy)), "Version") : false
    error_message = "resource_aws_ecr_registry_policy, policy must contain a 'Version' field."
  }

  validation {
    condition     = can(jsondecode(var.policy)) ? contains(keys(jsondecode(var.policy)), "Statement") : false
    error_message = "resource_aws_ecr_registry_policy, policy must contain a 'Statement' field."
  }
}