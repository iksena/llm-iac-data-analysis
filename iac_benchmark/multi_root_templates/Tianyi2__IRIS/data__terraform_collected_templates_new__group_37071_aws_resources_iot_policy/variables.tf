variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the policy."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9:_-]+$", var.name))
    error_message = "resource_aws_iot_policy, name must contain only alphanumeric characters, colons, underscores, and hyphens."
  }
}

variable "policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_iot_policy, policy must be a valid JSON formatted string."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}

variable "timeouts_update" {
  description = "Timeout for update operations."
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_update))
    error_message = "resource_aws_iot_policy, timeouts_update must be a valid duration format (e.g., 1m, 30s, 1h)."
  }
}

variable "timeouts_delete" {
  description = "Timeout for delete operations."
  type        = string
  default     = "5m"

  validation {
    condition     = can(regex("^[0-9]+(s|m|h)$", var.timeouts_delete))
    error_message = "resource_aws_iot_policy, timeouts_delete must be a valid duration format (e.g., 1m, 30s, 1h)."
  }
}