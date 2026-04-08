variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the State Machine alias"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_sfn_alias, name must not be empty."
  }
}

variable "statemachine_arn" {
  description = "ARN of the State Machine"
  type        = string

  validation {
    condition     = length(var.statemachine_arn) > 0 && can(regex("^arn:aws:states:", var.statemachine_arn))
    error_message = "data_aws_sfn_alias, statemachine_arn must be a valid Step Functions State Machine ARN."
  }
}