variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "topic_arn" {
  description = "The Amazon Resource Name (ARN) of the Amazon SNS topic. Can be set to empty string to disable publishing."
  type        = string
  default     = null
}

variable "notification_type" {
  description = "The type of notifications that will be published to the specified Amazon SNS topic."
  type        = string

  validation {
    condition     = contains(["Bounce", "Complaint", "Delivery"], var.notification_type)
    error_message = "resource_aws_ses_identity_notification_topic, notification_type must be one of: Bounce, Complaint, or Delivery."
  }
}

variable "identity" {
  description = "The identity for which the Amazon SNS topic will be set. You can specify an identity by using its name or by using its Amazon Resource Name (ARN)."
  type        = string
}

variable "include_original_headers" {
  description = "Whether SES should include original email headers in SNS notifications of this type."
  type        = bool
  default     = false
}