variable "topic_arn" {
  description = "ARN of the SNS topic to subscribe to"
  type        = string
}

variable "protocol" {
  description = "Protocol to use. Valid values are: sqs, sms, lambda, firehose, application, email, email-json, http, https"
  type        = string
  validation {
    condition = contains([
      "sqs", "sms", "lambda", "firehose", "application",
      "email", "email-json", "http", "https"
    ], var.protocol)
    error_message = "resource_aws_sns_topic_subscription, protocol must be one of: sqs, sms, lambda, firehose, application, email, email-json, http, https."
  }
}

variable "endpoint" {
  description = "Endpoint to send data to. The contents vary with the protocol"
  type        = string
}

variable "subscription_role_arn" {
  description = "ARN of the IAM role to publish to Kinesis Data Firehose delivery stream. Required if protocol is firehose"
  type        = string
  default     = null
  validation {
    condition     = var.protocol != "firehose" || var.subscription_role_arn != null
    error_message = "resource_aws_sns_topic_subscription, subscription_role_arn is required when protocol is firehose."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "confirmation_timeout_in_minutes" {
  description = "Integer indicating number of minutes to wait in retrying mode for fetching subscription arn before marking it as failure. Only applicable for http and https protocols"
  type        = number
  default     = 1
  validation {
    condition     = var.confirmation_timeout_in_minutes > 0
    error_message = "resource_aws_sns_topic_subscription, confirmation_timeout_in_minutes must be a positive integer."
  }
}

variable "delivery_policy" {
  description = "JSON String with the delivery policy (retries, backoff, etc.) that will be used in the subscription - this only applies to HTTP/S subscriptions"
  type        = string
  default     = null
  validation {
    condition     = var.delivery_policy == null || can(jsondecode(var.delivery_policy))
    error_message = "resource_aws_sns_topic_subscription, delivery_policy must be a valid JSON string."
  }
}

variable "endpoint_auto_confirms" {
  description = "Whether the endpoint is capable of auto confirming subscription"
  type        = bool
  default     = false
}

variable "filter_policy" {
  description = "JSON String with the filter policy that will be used in the subscription to filter messages seen by the target resource"
  type        = string
  default     = null
  validation {
    condition     = var.filter_policy == null || can(jsondecode(var.filter_policy))
    error_message = "resource_aws_sns_topic_subscription, filter_policy must be a valid JSON string."
  }
}

variable "filter_policy_scope" {
  description = "Whether the filter_policy applies to MessageAttributes (default) or MessageBody"
  type        = string
  default     = "MessageAttributes"
  validation {
    condition     = contains(["MessageAttributes", "MessageBody"], var.filter_policy_scope)
    error_message = "resource_aws_sns_topic_subscription, filter_policy_scope must be either MessageAttributes or MessageBody."
  }
}

variable "raw_message_delivery" {
  description = "Whether to enable raw message delivery (the original message is directly passed, not wrapped in JSON with the original message in the message property)"
  type        = bool
  default     = false
}

variable "redrive_policy" {
  description = "JSON String with the redrive policy that will be used in the subscription"
  type        = string
  default     = null
  validation {
    condition     = var.redrive_policy == null || can(jsondecode(var.redrive_policy))
    error_message = "resource_aws_sns_topic_subscription, redrive_policy must be a valid JSON string."
  }
}

variable "replay_policy" {
  description = "JSON String with the archived message replay policy that will be used in the subscription"
  type        = string
  default     = null
  validation {
    condition     = var.replay_policy == null || can(jsondecode(var.replay_policy))
    error_message = "resource_aws_sns_topic_subscription, replay_policy must be a valid JSON string."
  }
}