variable "name" {
  description = "This is the human-readable name of the queue. If omitted, Terraform will assign a random name."
  type        = string
  default     = "benchmark-queue"
}

variable "message_retention_seconds" {
  description = "The number of seconds Amazon SQS retains a message. Integer representing seconds, from 60 (1 minute) to 1209600 (14 days)"
  type        = number
  default     = 345600 # The default for this attribute is 345600 (4 days).
}

variable "visibility_timeout_seconds" {
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours)"
  type        = number
  default     = 30 # The default for this attribute is 30.
}

variable "fifo_queue" {
  description = "Boolean designating a FIFO queue"
  type        = bool
  default     = false
}



variable "content_based_deduplication" {
  description = "Enables content-based deduplication for FIFO queues"
  type        = bool
  default     = false
}

variable "kms_master_key_id" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SQS or a custom CMK"
  type        = string
  default     = ""
}

variable "kms_data_key_reuse_period_seconds" {
  description = "The length of time, in seconds, for which Amazon SQS can reuse a data key to encrypt or decrypt messages before calling AWS KMS again. An integer representing seconds, between 60 seconds (1 minute) and 86,400 seconds (24 hours)"
  type        = number
  default     = 300
}

variable "kms_master_key_id_sns" {
  description = "The ID of an AWS-managed customer master key (CMK) for Amazon SNS or a custom CMK"
  type        = string
  default     = ""
}

variable "max_message_size" {
  description = "The limit of how many bytes a message can contain before Amazon SQS rejects it. An integer from 1024 bytes (1 KiB) up to 262144 bytes (256 KiB)"
  type        = number
  default     = 262144
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}

variable "alarm_sns_topic_arn" {
  description = "ARN of the SNS topic for alarm notifactions"
  type        = string
  default     = ""
}

variable "policy_queue" {
  description = "A Policy custom of AWS account IDs allowed to access this resource"
  type        = string
  default     = ""
}

variable "policy_deadletter_queue" {
  description = "A Policy custom of AWS account IDs allowed to access this resource"
  type        = string
  default     = ""
}

variable "allowed_items_max" {
  description = "The maximum number of items allowed on the SQS queue before it triggers an alarm"
  type        = string
  default     = 10
}

variable "email" {
  description = "Email of the SNS topic for alarm notifactions"
  type        = string
  default     = ""
}
