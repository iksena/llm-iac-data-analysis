variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_opensearchserverless_access_policy, name cannot be empty."
  }
}

variable "policy" {
  description = "JSON policy document to use as the content for the new policy"
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_opensearchserverless_access_policy, policy cannot be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_opensearchserverless_access_policy, policy must be valid JSON."
  }
}

variable "type" {
  description = "Type of access policy. Must be 'data'"
  type        = string

  validation {
    condition     = var.type == "data"
    error_message = "resource_aws_opensearchserverless_access_policy, type must be 'data'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the policy. Typically used to store information about the permissions defined in the policy"
  type        = string
  default     = null
}