variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_guardduty_finding_ids, region must be a valid AWS region format (lowercase letters, numbers, and hyphens only)."
  }
}

variable "detector_id" {
  description = "ID of the GuardDuty detector."
  type        = string

  validation {
    condition     = length(var.detector_id) > 0
    error_message = "data_aws_guardduty_finding_ids, detector_id cannot be empty."
  }

  validation {
    condition     = can(regex("^[a-f0-9]{32}$", var.detector_id))
    error_message = "data_aws_guardduty_finding_ids, detector_id must be a valid 32-character hex string."
  }
}