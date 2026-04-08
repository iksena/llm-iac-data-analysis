variable "name" {
  description = "Name for the approval rule template. This needs to be less than 100 characters."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 100
    error_message = "data_codecommit_approval_rule_template, name must be between 1 and 100 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}