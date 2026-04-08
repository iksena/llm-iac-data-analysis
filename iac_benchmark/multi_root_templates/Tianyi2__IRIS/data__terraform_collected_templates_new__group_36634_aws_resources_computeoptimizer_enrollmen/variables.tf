variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "include_member_accounts" {
  description = "Whether to enroll member accounts of the organization if the account is the management account of an organization."
  type        = bool
  default     = false
}

variable "status" {
  description = "The enrollment status of the account."
  type        = string

  validation {
    condition     = contains(["Active", "Inactive"], var.status)
    error_message = "resource_aws_computeoptimizer_enrollment_status, status must be either 'Active' or 'Inactive'."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "5m")
    update = optional(string, "5m")
  })
  default = {
    create = "5m"
    update = "5m"
  }
}