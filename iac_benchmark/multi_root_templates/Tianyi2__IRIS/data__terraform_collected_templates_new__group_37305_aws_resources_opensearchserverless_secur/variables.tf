variable "name" {
  description = "Name of the policy"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_opensearchserverless_security_policy, name must not be empty."
  }
}

variable "policy" {
  description = "JSON policy document to use as the content for the new policy"
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_opensearchserverless_security_policy, policy must be a valid JSON document."
  }

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_opensearchserverless_security_policy, policy must not be empty."
  }
}

variable "type" {
  description = "Type of security policy. One of encryption or network"
  type        = string

  validation {
    condition     = contains(["encryption", "network"], var.type)
    error_message = "resource_aws_opensearchserverless_security_policy, type must be one of: encryption, network."
  }
}

variable "description" {
  description = "Description of the policy. Typically used to store information about the permissions defined in the policy"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}