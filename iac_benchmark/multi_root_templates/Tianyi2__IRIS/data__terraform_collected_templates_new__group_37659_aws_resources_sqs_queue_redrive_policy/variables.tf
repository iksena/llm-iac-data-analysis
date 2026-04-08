variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "queue_url" {
  description = "The URL of the SQS Queue to which to attach the policy"
  type        = string

  validation {
    condition     = can(regex("^https://sqs\\.[a-z0-9-]+\\.amazonaws\\.com/[0-9]+/[a-zA-Z0-9-_]+$", var.queue_url))
    error_message = "resource_aws_sqs_queue_redrive_policy, queue_url must be a valid SQS queue URL format."
  }
}

variable "redrive_policy" {
  description = "The JSON redrive policy for the SQS queue. Accepts two key/val pairs: deadLetterTargetArn and maxReceiveCount."
  type        = string

  validation {
    condition     = can(jsondecode(var.redrive_policy))
    error_message = "resource_aws_sqs_queue_redrive_policy, redrive_policy must be valid JSON."
  }

  validation {
    condition     = can(jsondecode(var.redrive_policy).deadLetterTargetArn) && can(jsondecode(var.redrive_policy).maxReceiveCount)
    error_message = "resource_aws_sqs_queue_redrive_policy, redrive_policy must contain deadLetterTargetArn and maxReceiveCount fields."
  }

  validation {
    condition     = can(regex("^arn:aws:sqs:[a-z0-9-]+:[0-9]+:[a-zA-Z0-9-_]+$", jsondecode(var.redrive_policy).deadLetterTargetArn))
    error_message = "resource_aws_sqs_queue_redrive_policy, redrive_policy deadLetterTargetArn must be a valid SQS queue ARN."
  }

  validation {
    condition     = jsondecode(var.redrive_policy).maxReceiveCount >= 1 && jsondecode(var.redrive_policy).maxReceiveCount <= 1000
    error_message = "resource_aws_sqs_queue_redrive_policy, redrive_policy maxReceiveCount must be between 1 and 1000."
  }
}