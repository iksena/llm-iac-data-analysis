variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues."
  type        = bool
  default     = null
}

variable "deduplication_scope" {
  description = "Specifies whether message deduplication occurs at the message group or queue level. Valid values are messageGroup and queue (default)."
  type        = string
  default     = null
  validation {
    condition     = var.deduplication_scope == null || contains(["messageGroup", "queue"], var.deduplication_scope)
    error_message = "resource_aws_sqs_queue, deduplication_scope must be either 'messageGroup' or 'queue'."
  }
}

variable "delay_seconds" {
  description = "Time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes). The default for this attribute is 0 seconds."
  type        = number
  default     = null
  validation {
    condition     = var.delay_seconds == null || (var.delay_seconds >= 0 && var.delay_seconds <= 900)
    error_message = "resource_aws_sqs_queue, delay_seconds must be an integer from 0 to 900."
  }
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue. If not set, it defaults to false making it standard."
  type        = bool
  default     = null
}

variable "fifo_throughput_limit" {
  description = "Specifies whether the FIFO queue throughput quota applies to the entire queue or per message group. Valid values are perQueue (default) and perMessageGroupId."
  type        = string
  default     = null
  validation {
    condition     = var.fifo_throughput_limit == null || contains(["perQueue", "perMessageGroupId"], var.fifo_throughput_limit)
    error_message = "resource_aws_sqs_queue, fifo_throughput_limit must be either 'perQueue' or 'perMessageGroupId'."
  }
}

variable "kms_data_key_reuse_period_seconds" {
  description = "Length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours). The default is 300 (5 minutes)."
  type        = number
  default     = null
  validation {
    condition     = var.kms_data_key_reuse_period_seconds == null || (var.kms_data_key_reuse_period_seconds >= 60 && var.kms_data_key_reuse_period_seconds <= 86400)
    error_message = "resource_aws_sqs_queue, kms_data_key_reuse_period_seconds must be an integer between 60 and 86400."
  }
}

variable "kms_master_key_id" {
  description = "ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK."
  type        = string
  default     = null
}

variable "max_message_size" {
  description = "Limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 1048576 bytes (1024 KiB). The default for this attribute is 262144 (256 KiB)."
  type        = number
  default     = null
  validation {
    condition     = var.max_message_size == null || (var.max_message_size >= 1024 && var.max_message_size <= 1048576)
    error_message = "resource_aws_sqs_queue, max_message_size must be an integer from 1024 to 1048576."
  }
}

variable "message_retention_seconds" {
  description = "Number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days). The default for this attribute is 345600 (4 days)."
  type        = number
  default     = null
  validation {
    condition     = var.message_retention_seconds == null || (var.message_retention_seconds >= 60 && var.message_retention_seconds <= 1209600)
    error_message = "resource_aws_sqs_queue, message_retention_seconds must be an integer from 60 to 1209600."
  }
}

variable "name" {
  description = "Name of the queue. Queue names must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long. For a FIFO (first-in-first-out) queue, the name must end with the .fifo suffix. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null
  validation {
    condition     = var.name == null || can(regex("^[A-Za-z0-9_-]{1,80}$", var.name))
    error_message = "resource_aws_sqs_queue, name must be made up of only uppercase and lowercase ASCII letters, numbers, underscores, and hyphens, and must be between 1 and 80 characters long."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name."
  type        = string
  default     = null
}

variable "policy" {
  description = "JSON policy for the SQS queue."
  type        = string
  default     = null
}

variable "receive_wait_time_seconds" {
  description = "Time for which a ReceiveMessage call will wait for a message to arrive (long polling) before returning. An integer from 0 to 20 (seconds). The default for this attribute is 0, meaning that the call will return immediately."
  type        = number
  default     = null
  validation {
    condition     = var.receive_wait_time_seconds == null || (var.receive_wait_time_seconds >= 0 && var.receive_wait_time_seconds <= 20)
    error_message = "resource_aws_sqs_queue, receive_wait_time_seconds must be an integer from 0 to 20."
  }
}

variable "redrive_allow_policy" {
  description = "JSON policy to set up the Dead Letter Queue redrive permission."
  type        = string
  default     = null
}

variable "redrive_policy" {
  description = "JSON policy to set up the Dead Letter Queue."
  type        = string
  default     = null
}

variable "sqs_managed_sse_enabled" {
  description = "Boolean to enable server-side encryption (SSE) of message content with SQS-owned encryption keys."
  type        = bool
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the queue."
  type        = map(string)
  default     = {}
}

variable "visibility_timeout_seconds" {
  description = "Visibility timeout for the queue. An integer from 0 to 43200 (12 hours). The default for this attribute is 30."
  type        = number
  default     = null
  validation {
    condition     = var.visibility_timeout_seconds == null || (var.visibility_timeout_seconds >= 0 && var.visibility_timeout_seconds <= 43200)
    error_message = "resource_aws_sqs_queue, visibility_timeout_seconds must be an integer from 0 to 43200."
  }
}