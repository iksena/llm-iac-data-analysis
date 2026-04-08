variable "pool_name" {
  description = "Name of the dedicated IP pool"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9_-]+$", var.pool_name))
    error_message = "resource_aws_sesv2_dedicated_ip_pool, pool_name must contain only alphanumeric characters, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "scaling_mode" {
  description = "IP pool scaling mode. Valid values: STANDARD, MANAGED. If omitted, the AWS API will default to a standard pool"
  type        = string
  default     = null

  validation {
    condition     = var.scaling_mode == null || contains(["STANDARD", "MANAGED"], var.scaling_mode)
    error_message = "resource_aws_sesv2_dedicated_ip_pool, scaling_mode must be either STANDARD or MANAGED."
  }
}

variable "tags" {
  description = "A map of tags to assign to the pool"
  type        = map(string)
  default     = {}
}