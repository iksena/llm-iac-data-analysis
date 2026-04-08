variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "suppressed_reasons" {
  description = "A list that contains the reasons that email addresses will be automatically added to the suppression list for your account."
  type        = list(string)

  validation {
    condition = alltrue([
      for reason in var.suppressed_reasons : contains(["COMPLAINT", "BOUNCE"], reason)
    ])
    error_message = "resource_aws_sesv2_account_suppression_attributes, suppressed_reasons must contain only valid values: COMPLAINT, BOUNCE."
  }

  validation {
    condition     = length(var.suppressed_reasons) > 0
    error_message = "resource_aws_sesv2_account_suppression_attributes, suppressed_reasons must contain at least one value."
  }
}