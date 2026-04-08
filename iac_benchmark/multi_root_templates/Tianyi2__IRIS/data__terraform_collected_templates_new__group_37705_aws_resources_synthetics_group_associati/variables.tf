variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "group_name" {
  description = "Name of the group that the canary will be associated with."
  type        = string

  validation {
    condition     = length(var.group_name) > 0
    error_message = "resource_aws_synthetics_group_association, group_name must not be empty."
  }
}

variable "canary_arn" {
  description = "ARN of the canary."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:synthetics:", var.canary_arn))
    error_message = "resource_aws_synthetics_group_association, canary_arn must be a valid AWS Synthetics canary ARN."
  }
}