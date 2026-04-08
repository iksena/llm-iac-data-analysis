variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "A name for the subscription filter"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_cloudwatch_log_subscription_filter, name must not be empty."
  }
}

variable "destination_arn" {
  description = "The ARN of the destination to deliver matching log events to. Kinesis stream or Lambda function ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:[a-z0-9][a-z0-9\\-]*:[a-z0-9\\-]*:[0-9]{12}:.*$", var.destination_arn))
    error_message = "resource_aws_cloudwatch_log_subscription_filter, destination_arn must be a valid ARN."
  }
}

variable "filter_pattern" {
  description = "A valid CloudWatch Logs filter pattern for subscribing to a filtered stream of log events. Use empty string \"\" to match everything."
  type        = string
}

variable "log_group_name" {
  description = "The name of the log group to associate the subscription filter with"
  type        = string

  validation {
    condition     = length(var.log_group_name) > 0
    error_message = "resource_aws_cloudwatch_log_subscription_filter, log_group_name must not be empty."
  }
}

variable "role_arn" {
  description = "The ARN of an IAM role that grants Amazon CloudWatch Logs permissions to deliver ingested log events to the destination. If you use Lambda as a destination, you should skip this argument and use aws_lambda_permission resource for granting access from CloudWatch logs to the destination Lambda function."
  type        = string
  default     = null

  validation {
    condition     = var.role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.*$", var.role_arn))
    error_message = "resource_aws_cloudwatch_log_subscription_filter, role_arn must be a valid IAM role ARN when specified."
  }
}

variable "distribution" {
  description = "The method used to distribute log data to the destination. By default log data is grouped by log stream, but the grouping can be set to random for a more even distribution. This property is only applicable when the destination is an Amazon Kinesis stream. Valid values are \"Random\" and \"ByLogStream\"."
  type        = string
  default     = null

  validation {
    condition     = var.distribution == null || contains(["Random", "ByLogStream"], var.distribution)
    error_message = "resource_aws_cloudwatch_log_subscription_filter, distribution must be either \"Random\" or \"ByLogStream\" when specified."
  }
}