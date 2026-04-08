variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "arn" {
  description = "ARN of the Job Definition"
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:batch:[^:]+:[0-9]+:job-definition/[^:]+", var.arn))
    error_message = "data_aws_batch_job_definition, arn must be a valid AWS Batch Job Definition ARN."
  }
}

variable "revision" {
  description = "The revision of the job definition"
  type        = number
  default     = null

  validation {
    condition     = var.revision == null || var.revision >= 1
    error_message = "data_aws_batch_job_definition, revision must be a positive integer."
  }
}

variable "name" {
  description = "The name of the job definition to register. It can be up to 128 letters long. It can contain uppercase and lowercase letters, numbers, hyphens (-), and underscores (_)"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || (length(var.name) <= 128 && can(regex("^[a-zA-Z0-9_-]+$", var.name)))
    error_message = "data_aws_batch_job_definition, name must be up to 128 characters long and contain only letters, numbers, hyphens, and underscores."
  }
}

variable "status" {
  description = "The status of the job definition"
  type        = string
  default     = null
}