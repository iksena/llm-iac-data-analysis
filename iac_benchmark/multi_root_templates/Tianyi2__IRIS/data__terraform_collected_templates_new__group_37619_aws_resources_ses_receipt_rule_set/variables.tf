variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "rule_set_name" {
  type        = string
  description = "Name of the rule set."

  validation {
    condition     = var.rule_set_name != null && length(var.rule_set_name) > 0
    error_message = "resource_aws_ses_receipt_rule_set, rule_set_name must be a non-empty string."
  }
}