variable "readiness_check_name" {
  description = "Unique name describing the readiness check"
  type        = string

  validation {
    condition     = length(var.readiness_check_name) > 0
    error_message = "resource_aws_route53recoveryreadiness_readiness_check, readiness_check_name must not be empty."
  }
}

variable "resource_set_name" {
  description = "Name describing the resource set that will be monitored for readiness"
  type        = string

  validation {
    condition     = length(var.resource_set_name) > 0
    error_message = "resource_aws_route53recoveryreadiness_readiness_check, resource_set_name must not be empty."
  }
}

variable "tags" {
  description = "Key-value mapping of resource tags"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration block for operation timeouts"
  type = object({
    delete = optional(string, "5m")
  })
  default = null
}