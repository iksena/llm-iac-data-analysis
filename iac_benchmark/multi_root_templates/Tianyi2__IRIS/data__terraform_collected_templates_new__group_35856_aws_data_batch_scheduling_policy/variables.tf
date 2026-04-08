variable "arn" {
  description = "ARN of the scheduling policy"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:batch:", var.arn))
    error_message = "data_aws_batch_scheduling_policy, arn must be a valid ARN for a Batch scheduling policy."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_batch_scheduling_policy, region must be a valid AWS region format."
  }
}