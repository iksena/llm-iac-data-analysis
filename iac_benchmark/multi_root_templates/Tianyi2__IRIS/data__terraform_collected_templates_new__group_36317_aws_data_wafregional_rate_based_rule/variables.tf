variable "name" {
  description = "Name of the WAF Regional rate based rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_wafregional_rate_based_rule, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_wafregional_rate_based_rule, region must be a valid AWS region identifier or null."
  }
}