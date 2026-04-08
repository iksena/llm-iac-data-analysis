variable "name" {
  description = "Name of the NotificationConfiguration. Supports RFC 3986's unreserved characters. Length constraints: Minimum length of 1, maximum length of 64."
  type        = string

  validation {
    condition     = can(regex("^[A-Za-z0-9_\\-]+$", var.name)) && length(var.name) >= 1 && length(var.name) <= 64
    error_message = "resource_aws_notifications_notification_configuration, name must match pattern [A-Za-z0-9_\\-]+ and be between 1 and 64 characters."
  }
}

variable "description" {
  description = "Description of the NotificationConfiguration. Length constraints: Minimum length of 0, maximum length of 256."
  type        = string

  validation {
    condition     = length(var.description) >= 0 && length(var.description) <= 256
    error_message = "resource_aws_notifications_notification_configuration, description must be between 0 and 256 characters."
  }
}

variable "aggregation_duration" {
  description = "Aggregation preference of the NotificationConfiguration. Valid values: LONG (aggregate notifications for 12 hours), SHORT (aggregate notifications for 5 minutes), NONE (don't aggregate notifications)."
  type        = string
  default     = "NONE"

  validation {
    condition     = contains(["LONG", "SHORT", "NONE"], var.aggregation_duration)
    error_message = "resource_aws_notifications_notification_configuration, aggregation_duration must be one of: LONG, SHORT, NONE."
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource. A tag is a string-to-string map of key-value pairs."
  type        = map(string)
  default     = {}
}