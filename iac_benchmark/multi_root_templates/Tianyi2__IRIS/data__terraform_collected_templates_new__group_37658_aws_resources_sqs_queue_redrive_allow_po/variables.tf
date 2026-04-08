variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_sqs_queue_redrive_allow_policy, region must be a valid AWS region identifier or null."
  }
}

variable "queue_url" {
  description = "The URL of the SQS Queue to which to attach the policy"
  type        = string

  validation {
    condition     = can(regex("^https://sqs\\.[a-z0-9-]+\\.amazonaws\\.com/[0-9]+/.+$", var.queue_url)) || can(regex("^https://queue\\.amazonaws\\.com/[0-9]+/.+$", var.queue_url))
    error_message = "resource_aws_sqs_queue_redrive_allow_policy, queue_url must be a valid SQS queue URL."
  }
}

variable "redrive_allow_policy" {
  description = "The JSON redrive allow policy for the SQS queue"
  type        = string

  validation {
    condition     = can(jsondecode(var.redrive_allow_policy))
    error_message = "resource_aws_sqs_queue_redrive_allow_policy, redrive_allow_policy must be valid JSON."
  }
}