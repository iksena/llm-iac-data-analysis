variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_sfn_activity, region must be a valid AWS region format."
  }
}

variable "name" {
  description = "Name that identifies the activity."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_sfn_activity, name must not be empty if specified."
  }
}

variable "arn" {
  description = "ARN that identifies the activity."
  type        = string
  default     = null

  validation {
    condition     = var.arn == null || can(regex("^arn:aws:states:[a-z0-9-]+:[0-9]{12}:activity:", var.arn))
    error_message = "data_aws_sfn_activity, arn must be a valid Step Functions activity ARN format."
  }
}