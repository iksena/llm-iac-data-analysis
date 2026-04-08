variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "group_names" {
  description = "List of AutoScaling Group Names"
  type        = list(string)

  validation {
    condition     = length(var.group_names) > 0
    error_message = "resource_aws_autoscaling_notification, group_names must contain at least one AutoScaling Group Name."
  }
}

variable "notifications" {
  description = "List of Notification Types that trigger notifications. Acceptable values are documented in the AWS documentation."
  type        = list(string)

  validation {
    condition     = length(var.notifications) > 0
    error_message = "resource_aws_autoscaling_notification, notifications must contain at least one notification type."
  }

  validation {
    condition = alltrue([
      for notification in var.notifications : contains([
        "autoscaling:EC2_INSTANCE_LAUNCH",
        "autoscaling:EC2_INSTANCE_TERMINATE",
        "autoscaling:EC2_INSTANCE_LAUNCH_ERROR",
        "autoscaling:EC2_INSTANCE_TERMINATE_ERROR",
        "autoscaling:TEST_NOTIFICATION"
      ], notification)
    ])
    error_message = "resource_aws_autoscaling_notification, notifications must contain valid notification types: autoscaling:EC2_INSTANCE_LAUNCH, autoscaling:EC2_INSTANCE_TERMINATE, autoscaling:EC2_INSTANCE_LAUNCH_ERROR, autoscaling:EC2_INSTANCE_TERMINATE_ERROR, autoscaling:TEST_NOTIFICATION."
  }
}

variable "topic_arn" {
  description = "Topic ARN for notifications to be sent through"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:sns:", var.topic_arn))
    error_message = "resource_aws_autoscaling_notification, topic_arn must be a valid SNS topic ARN starting with 'arn:aws:sns:'."
  }
}