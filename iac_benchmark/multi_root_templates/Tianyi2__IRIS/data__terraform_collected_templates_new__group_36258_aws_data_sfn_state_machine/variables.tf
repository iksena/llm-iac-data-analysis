variable "name" {
  description = "Friendly name of the state machine to match"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_sfn_state_machine, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_sfn_state_machine, region must be a valid AWS region format (e.g., us-west-2) or null."
  }
}