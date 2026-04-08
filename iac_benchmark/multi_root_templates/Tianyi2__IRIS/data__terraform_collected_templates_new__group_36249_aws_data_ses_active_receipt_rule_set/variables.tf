variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.region))
    error_message = "data_aws_ses_active_receipt_rule_set, region must be a valid AWS region format or null."
  }
}