variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "monthly_spend_limit" {
  description = "The maximum amount in USD that you are willing to spend each month to send SMS messages."
  type        = number
  default     = null

  validation {
    condition     = var.monthly_spend_limit == null || var.monthly_spend_limit >= 0
    error_message = "resource_aws_sns_sms_preferences, monthly_spend_limit must be a non-negative number."
  }
}

variable "delivery_status_iam_role_arn" {
  description = "The ARN of the IAM role that allows Amazon SNS to write logs about SMS deliveries in CloudWatch Logs."
  type        = string
  default     = null

  validation {
    condition     = var.delivery_status_iam_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.delivery_status_iam_role_arn))
    error_message = "resource_aws_sns_sms_preferences, delivery_status_iam_role_arn must be a valid IAM role ARN."
  }
}

variable "delivery_status_success_sampling_rate" {
  description = "The percentage of successful SMS deliveries for which Amazon SNS will write logs in CloudWatch Logs. The value must be between 0 and 100."
  type        = number
  default     = null

  validation {
    condition     = var.delivery_status_success_sampling_rate == null || (var.delivery_status_success_sampling_rate >= 0 && var.delivery_status_success_sampling_rate <= 100)
    error_message = "resource_aws_sns_sms_preferences, delivery_status_success_sampling_rate must be between 0 and 100."
  }
}

variable "default_sender_id" {
  description = "A string, such as your business brand, that is displayed as the sender on the receiving device."
  type        = string
  default     = null
}

variable "default_sms_type" {
  description = "The type of SMS message that you will send by default. Possible values are: Promotional, Transactional"
  type        = string
  default     = null

  validation {
    condition     = var.default_sms_type == null || contains(["Promotional", "Transactional"], var.default_sms_type)
    error_message = "resource_aws_sns_sms_preferences, default_sms_type must be either 'Promotional' or 'Transactional'."
  }
}

variable "usage_report_s3_bucket" {
  description = "The name of the Amazon S3 bucket to receive daily SMS usage reports from Amazon SNS."
  type        = string
  default     = null

  validation {
    condition     = var.usage_report_s3_bucket == null || can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.usage_report_s3_bucket))
    error_message = "resource_aws_sns_sms_preferences, usage_report_s3_bucket must be a valid S3 bucket name."
  }
}