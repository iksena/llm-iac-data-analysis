variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the topic. Topic names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 256 characters long. For a FIFO (first-in-first-out) topic, the name must end with the .fifo suffix. Conflicts with name_prefix"
  type        = string
  default     = null

  validation {
    condition = var.name == null || (
      can(regex("^[a-zA-Z0-9_-]+$", var.name)) &&
      length(var.name) >= 1 &&
      length(var.name) <= 256
    )
    error_message = "resource_aws_sns_topic, name must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 256 characters long."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name"
  type        = string
  default     = null
}

variable "display_name" {
  description = "The display name for the topic"
  type        = string
  default     = null
}

variable "policy" {
  description = "The fully-formed AWS policy as JSON"
  type        = string
  default     = null
}

variable "delivery_policy" {
  description = "The SNS delivery policy"
  type        = string
  default     = null
}

variable "application_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "application_success_feedback_sample_rate" {
  description = "Percentage of success to sample"
  type        = number
  default     = null

  validation {
    condition     = var.application_success_feedback_sample_rate == null || (var.application_success_feedback_sample_rate >= 0 && var.application_success_feedback_sample_rate <= 100)
    error_message = "resource_aws_sns_topic, application_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "application_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "http_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "http_success_feedback_sample_rate" {
  description = "Percentage of success to sample"
  type        = number
  default     = null

  validation {
    condition     = var.http_success_feedback_sample_rate == null || (var.http_success_feedback_sample_rate >= 0 && var.http_success_feedback_sample_rate <= 100)
    error_message = "resource_aws_sns_topic, http_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "http_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = null
}

variable "signature_version" {
  description = "If SignatureVersion should be 1 (SHA1) or 2 (SHA256)"
  type        = number
  default     = null

  validation {
    condition     = var.signature_version == null || contains([1, 2], var.signature_version)
    error_message = "resource_aws_sns_topic, signature_version must be 1 (SHA1) or 2 (SHA256)."
  }
}

variable "tracing_config" {
  description = "Tracing mode of an Amazon SNS topic. Valid values: PassThrough, Active"
  type        = string
  default     = null

  validation {
    condition     = var.tracing_config == null || contains(["PassThrough", "Active"], var.tracing_config)
    error_message = "resource_aws_sns_topic, tracing_config must be either PassThrough or Active."
  }
}

variable "fifo_throughput_scope" {
  description = "Enables higher throughput for FIFO topics by adjusting the scope of deduplication. Valid values: Topic, MessageGroup"
  type        = string
  default     = null

  validation {
    condition     = var.fifo_throughput_scope == null || contains(["Topic", "MessageGroup"], var.fifo_throughput_scope)
    error_message = "resource_aws_sns_topic, fifo_throughput_scope must be either Topic or MessageGroup."
  }
}

variable "fifo_topic" {
  description = "Boolean indicating whether or not to create a FIFO (first-in-first-out) topic"
  type        = bool
  default     = false
}

variable "archive_policy" {
  description = "The message archive policy for FIFO topics"
  type        = string
  default     = null
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO topics"
  type        = bool
  default     = null
}

variable "lambda_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "lambda_success_feedback_sample_rate" {
  description = "Percentage of success to sample"
  type        = number
  default     = null

  validation {
    condition     = var.lambda_success_feedback_sample_rate == null || (var.lambda_success_feedback_sample_rate >= 0 && var.lambda_success_feedback_sample_rate <= 100)
    error_message = "resource_aws_sns_topic, lambda_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "lambda_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "sqs_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "sqs_success_feedback_sample_rate" {
  description = "Percentage of success to sample"
  type        = number
  default     = null

  validation {
    condition     = var.sqs_success_feedback_sample_rate == null || (var.sqs_success_feedback_sample_rate >= 0 && var.sqs_success_feedback_sample_rate <= 100)
    error_message = "resource_aws_sns_topic, sqs_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "sqs_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "firehose_success_feedback_role_arn" {
  description = "The IAM role permitted to receive success feedback for this topic"
  type        = string
  default     = null
}

variable "firehose_success_feedback_sample_rate" {
  description = "Percentage of success to sample"
  type        = number
  default     = null

  validation {
    condition     = var.firehose_success_feedback_sample_rate == null || (var.firehose_success_feedback_sample_rate >= 0 && var.firehose_success_feedback_sample_rate <= 100)
    error_message = "resource_aws_sns_topic, firehose_success_feedback_sample_rate must be between 0 and 100."
  }
}

variable "firehose_failure_feedback_role_arn" {
  description = "IAM role for failure feedback"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}