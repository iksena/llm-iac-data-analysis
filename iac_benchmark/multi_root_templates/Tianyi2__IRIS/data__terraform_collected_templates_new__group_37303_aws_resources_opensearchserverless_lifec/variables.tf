variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_opensearchserverless_lifecycle_policy, name must not be empty."
  }
}

variable "policy" {
  description = "JSON policy document to use as the content for the new policy"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_opensearchserverless_lifecycle_policy, policy must be valid JSON."
  }
}

variable "type" {
  description = "Type of lifecycle policy"
  type        = string

  validation {
    condition     = var.type == "retention"
    error_message = "resource_aws_opensearchserverless_lifecycle_policy, type must be 'retention'."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the policy"
  type        = string
  default     = null
}