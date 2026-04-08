variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "detector_id" {
  description = "The detector ID of the member GuardDuty account."
  type        = string

  validation {
    condition     = length(var.detector_id) > 0
    error_message = "resource_aws_guardduty_invite_accepter, detector_id must be a non-empty string."
  }
}

variable "master_account_id" {
  description = "AWS account ID for primary account."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.master_account_id))
    error_message = "resource_aws_guardduty_invite_accepter, master_account_id must be a 12-digit AWS account ID."
  }
}

variable "timeouts_create" {
  description = "Timeout for create operation."
  type        = string
  default     = "1m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_create))
    error_message = "resource_aws_guardduty_invite_accepter, timeouts_create must be a valid duration string (e.g., '1m', '30s', '1h')."
  }
}