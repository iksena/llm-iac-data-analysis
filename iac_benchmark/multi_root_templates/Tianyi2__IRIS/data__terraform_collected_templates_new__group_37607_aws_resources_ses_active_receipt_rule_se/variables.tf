variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_ses_active_receipt_rule_set, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}

variable "rule_set_name" {
  description = "The name of the rule set"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.rule_set_name)) && length(var.rule_set_name) > 0 && length(var.rule_set_name) <= 64
    error_message = "resource_aws_ses_active_receipt_rule_set, rule_set_name must be 1-64 characters long and contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}