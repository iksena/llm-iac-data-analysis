variable "registry_name" {
  description = "Name of EventBridge Schema Registry"
  type        = string

  validation {
    condition     = length(var.registry_name) > 0
    error_message = "resource_aws_schemas_registry_policy, registry_name must not be empty."
  }
}

variable "policy" {
  description = "Resource Policy for EventBridge Schema Registry"
  type        = string

  validation {
    condition     = length(var.policy) > 0
    error_message = "resource_aws_schemas_registry_policy, policy must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_schemas_registry_policy, policy must be a valid JSON string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

