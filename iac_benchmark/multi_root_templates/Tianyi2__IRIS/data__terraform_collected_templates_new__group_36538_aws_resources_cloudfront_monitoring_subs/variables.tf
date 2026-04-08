variable "distribution_id" {
  description = "The ID of the distribution that you are enabling metrics for."
  type        = string

  validation {
    condition     = can(regex("^[A-Z0-9]{14}$", var.distribution_id))
    error_message = "resource_aws_cloudfront_monitoring_subscription, distribution_id must be a valid CloudFront distribution ID (14 uppercase alphanumeric characters)."
  }
}

variable "realtime_metrics_subscription_status" {
  description = "A flag that indicates whether additional CloudWatch metrics are enabled for a given CloudFront distribution."
  type        = string

  validation {
    condition     = contains(["Enabled", "Disabled"], var.realtime_metrics_subscription_status)
    error_message = "resource_aws_cloudfront_monitoring_subscription, realtime_metrics_subscription_status must be either 'Enabled' or 'Disabled'."
  }
}