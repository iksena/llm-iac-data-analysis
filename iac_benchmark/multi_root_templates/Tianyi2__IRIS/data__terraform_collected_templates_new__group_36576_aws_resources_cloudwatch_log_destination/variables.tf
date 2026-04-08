variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "destination_name" {
  description = "A name for the subscription filter"
  type        = string

  validation {
    condition     = length(var.destination_name) > 0
    error_message = "resource_aws_cloudwatch_log_destination_policy, destination_name must not be empty."
  }
}

variable "access_policy" {
  description = "The policy document. This is a JSON formatted string."
  type        = string

  validation {
    condition     = length(var.access_policy) > 0
    error_message = "resource_aws_cloudwatch_log_destination_policy, access_policy must not be empty."
  }

  validation {
    condition     = can(jsondecode(var.access_policy))
    error_message = "resource_aws_cloudwatch_log_destination_policy, access_policy must be a valid JSON string."
  }
}

variable "force_update" {
  description = "Specify true if you are updating an existing destination policy to grant permission to an organization ID instead of granting permission to individual AWS accounts."
  type        = bool
  default     = null
}