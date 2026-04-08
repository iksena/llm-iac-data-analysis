variable "arn" {
  description = "ARN of the channel to associate with the notification configuration. This can be an email contact ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:", var.arn))
    error_message = "resource_aws_notifications_channel_association, arn must be a valid ARN starting with 'arn:aws:'."
  }
}

variable "notification_configuration_arn" {
  description = "ARN of the notification configuration to associate the channel with."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:notifications:", var.notification_configuration_arn))
    error_message = "resource_aws_notifications_channel_association, notification_configuration_arn must be a valid notification configuration ARN starting with 'arn:aws:notifications:'."
  }
}