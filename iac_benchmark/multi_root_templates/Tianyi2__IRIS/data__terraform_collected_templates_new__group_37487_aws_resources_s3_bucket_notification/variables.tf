variable "bucket" {
  description = "Name of the bucket for notification configuration"
  type        = string

  validation {
    condition     = length(var.bucket) > 0
    error_message = "resource_aws_s3_bucket_notification, bucket must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "eventbridge" {
  description = "Whether to enable Amazon EventBridge notifications"
  type        = bool
  default     = false
}

variable "lambda_function" {
  description = "Configuration for notifications to Lambda Functions"
  type = list(object({
    events              = list(string)
    filter_prefix       = optional(string)
    filter_suffix       = optional(string)
    id                  = optional(string)
    lambda_function_arn = string
  }))
  default = []

  validation {
    condition = alltrue([
      for lf in var.lambda_function : length(lf.events) > 0
    ])
    error_message = "resource_aws_s3_bucket_notification, lambda_function events must not be empty."
  }

  validation {
    condition = alltrue([
      for lf in var.lambda_function : length(lf.lambda_function_arn) > 0
    ])
    error_message = "resource_aws_s3_bucket_notification, lambda_function lambda_function_arn must not be empty."
  }
}

variable "queue" {
  description = "Configuration for notifications to SQS Queues"
  type = list(object({
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
    id            = optional(string)
    queue_arn     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for q in var.queue : length(q.events) > 0
    ])
    error_message = "resource_aws_s3_bucket_notification, queue events must not be empty."
  }

  validation {
    condition = alltrue([
      for q in var.queue : length(q.queue_arn) > 0
    ])
    error_message = "resource_aws_s3_bucket_notification, queue queue_arn must not be empty."
  }
}

variable "topic" {
  description = "Configuration for notifications to SNS Topics"
  type = list(object({
    events        = list(string)
    filter_prefix = optional(string)
    filter_suffix = optional(string)
    id            = optional(string)
    topic_arn     = string
  }))
  default = []

  validation {
    condition = alltrue([
      for t in var.topic : length(t.events) > 0
    ])
    error_message = "resource_aws_s3_bucket_notification, topic events must not be empty."
  }

  validation {
    condition = alltrue([
      for t in var.topic : length(t.topic_arn) > 0
    ])
    error_message = "resource_aws_s3_bucket_notification, topic topic_arn must not be empty."
  }
}