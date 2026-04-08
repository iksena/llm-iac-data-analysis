variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_securityhub_standards_subscription, region must be a valid AWS region format or null."
  }
}

variable "standards_arn" {
  description = "The ARN of a standard"
  type        = string

  validation {
    condition     = can(regex("^arn:[^:]*:securityhub:", var.standards_arn))
    error_message = "resource_aws_securityhub_standards_subscription, standards_arn must be a valid SecurityHub standards ARN."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "3m")
    delete = optional(string, "3m")
  })
  default = {
    create = "3m"
    delete = "3m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create)) && can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_securityhub_standards_subscription, timeouts must be valid duration strings (e.g., '3m', '30s', '1h')."
  }
}