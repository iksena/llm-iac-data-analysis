variable "notification_hub_region" {
  description = "Notification Hub region."
  type        = string

  validation {
    condition     = length(var.notification_hub_region) > 0
    error_message = "resource_aws_notifications_notification_hub, notification_hub_region must not be empty."
  }
}