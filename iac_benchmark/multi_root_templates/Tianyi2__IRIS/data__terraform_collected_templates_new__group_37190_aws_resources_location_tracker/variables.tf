variable "tracker_name" {
  description = "The name of the tracker resource"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.tracker_name)) && length(var.tracker_name) >= 1 && length(var.tracker_name) <= 100
    error_message = "resource_aws_location_tracker, tracker_name must be a valid tracker name containing only alphanumeric characters, periods, underscores, and hyphens, and must be between 1 and 100 characters long."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "description" {
  description = "The optional description for the tracker resource"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1000
    error_message = "resource_aws_location_tracker, description must be 1000 characters or less."
  }
}

variable "kms_key_id" {
  description = "A key identifier for an AWS KMS customer managed key assigned to the Amazon Location resource"
  type        = string
  default     = null
}

variable "position_filtering" {
  description = "The position filtering method of the tracker resource. Valid values: TimeBased, DistanceBased, AccuracyBased. Default: TimeBased"
  type        = string
  default     = "TimeBased"

  validation {
    condition     = contains(["TimeBased", "DistanceBased", "AccuracyBased"], var.position_filtering)
    error_message = "resource_aws_location_tracker, position_filtering must be one of: TimeBased, DistanceBased, AccuracyBased."
  }
}

variable "tags" {
  description = "Key-value tags for the tracker. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level"
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : length(k) <= 128 && length(v) <= 256])
    error_message = "resource_aws_location_tracker, tags keys must be 128 characters or less and values must be 256 characters or less."
  }
}