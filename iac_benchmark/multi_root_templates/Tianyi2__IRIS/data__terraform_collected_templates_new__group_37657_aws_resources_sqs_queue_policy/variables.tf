variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "policy" {
  description = "JSON policy for the SQS queue. Ensure that Version = \"2012-10-17\" is set in the policy or AWS may hang in creating the queue."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_sqs_queue_policy, policy must be valid JSON."
  }

  validation {
    condition     = can(regex("\"Version\"\\s*:\\s*\"2012-10-17\"", var.policy))
    error_message = "resource_aws_sqs_queue_policy, policy must include Version = \"2012-10-17\" to prevent AWS from hanging during resource creation/update."
  }
}

variable "queue_url" {
  description = "URL of the SQS Queue to which to attach the policy."
  type        = string

  validation {
    condition     = can(regex("^https://queue\\.amazonaws\\.com/.+", var.queue_url))
    error_message = "resource_aws_sqs_queue_policy, queue_url must be a valid SQS queue URL starting with https://queue.amazonaws.com/."
  }
}