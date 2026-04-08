variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the archive. The archive name cannot exceed 48 characters."
  type        = string

  validation {
    condition     = length(var.name) <= 48
    error_message = "resource_aws_cloudwatch_event_archive, name: The archive name cannot exceed 48 characters."
  }
}

variable "event_source_arn" {
  description = "ARN of the event bus associated with the archive. Only events from this event bus are sent to the archive."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-z0-9-]*:events:", var.event_source_arn))
    error_message = "resource_aws_cloudwatch_event_archive, event_source_arn: Must be a valid EventBridge event bus ARN."
  }
}

variable "description" {
  description = "Description for the archive."
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "Event pattern to use to filter events sent to the archive. By default, it attempts to archive every event received in the event_source_arn."
  type        = string
  default     = null

  validation {
    condition     = var.event_pattern == null || can(jsondecode(var.event_pattern))
    error_message = "resource_aws_cloudwatch_event_archive, event_pattern: Must be a valid JSON string."
  }
}

variable "kms_key_identifier" {
  description = "Identifier of the AWS KMS customer managed key for EventBridge to use, if you choose to use a customer managed key to encrypt this archive. The identifier can be the key Amazon Resource Name (ARN), KeyId, key alias, or key alias ARN."
  type        = string
  default     = null
}

variable "retention_days" {
  description = "The maximum number of days to retain events in the new event archive. By default, it archives indefinitely."
  type        = number
  default     = null

  validation {
    condition     = var.retention_days == null || var.retention_days > 0
    error_message = "resource_aws_cloudwatch_event_archive, retention_days: Must be a positive number."
  }
}