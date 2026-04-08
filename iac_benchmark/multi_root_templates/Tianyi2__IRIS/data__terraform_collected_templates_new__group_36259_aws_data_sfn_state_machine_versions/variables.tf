variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "statemachine_arn" {
  description = "ARN of the State Machine."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:states:[a-zA-Z0-9-]+:[0-9]{12}:stateMachine:.+", var.statemachine_arn))
    error_message = "data_aws_sfn_state_machine_versions, statemachine_arn must be a valid Step Functions State Machine ARN."
  }
}