variable "name" {
  description = "Name of the WAF Regional rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_wafregional_rule, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]{1}$", var.region)) || can(regex("^[a-z]{2}-[a-z]+-[a-z]{1}-[0-9]{1}$", var.region)) || can(regex("^us-gov-[a-z]+-[0-9]{1}$", var.region))
    error_message = "data_aws_wafregional_rule, region must be a valid AWS region format."
  }
}