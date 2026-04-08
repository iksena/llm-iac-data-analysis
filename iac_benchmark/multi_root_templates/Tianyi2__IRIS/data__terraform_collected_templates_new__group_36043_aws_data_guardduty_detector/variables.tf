variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_guardduty_detector, region must be a valid AWS region format or null."
  }
}

variable "id" {
  description = "ID of the detector."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || length(var.id) > 0
    error_message = "data_aws_guardduty_detector, id must be a non-empty string or null."
  }
}