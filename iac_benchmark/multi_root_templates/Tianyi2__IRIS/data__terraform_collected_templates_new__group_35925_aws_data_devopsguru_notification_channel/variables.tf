variable "id" {
  description = "Unique identifier for the notification channel."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-_]+$", var.id))
    error_message = "data_aws_devopsguru_notification_channel, id must be a valid identifier containing only alphanumeric characters, hyphens, and underscores."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_devopsguru_notification_channel, region must be a valid AWS region identifier or null."
  }
}