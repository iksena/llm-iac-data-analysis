variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "AWS account ID for member account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_guardduty_member, account_id must be a 12-digit AWS account ID."
  }
}

variable "detector_id" {
  description = "The detector ID of the GuardDuty account where you want to create member accounts."
  type        = string

  validation {
    condition     = length(var.detector_id) > 0
    error_message = "resource_aws_guardduty_member, detector_id cannot be empty."
  }
}

variable "email" {
  description = "Email address for member account."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.email))
    error_message = "resource_aws_guardduty_member, email must be a valid email address."
  }
}

variable "invite" {
  description = "Boolean whether to invite the account to GuardDuty as a member. Defaults to false."
  type        = bool
  default     = false
}

variable "invitation_message" {
  description = "Message for invitation."
  type        = string
  default     = null
}

variable "disable_email_notification" {
  description = "Boolean whether an email notification is sent to the accounts. Defaults to false."
  type        = bool
  default     = false
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string, "1m")
    update = optional(string, "1m")
  })
  default = null
}