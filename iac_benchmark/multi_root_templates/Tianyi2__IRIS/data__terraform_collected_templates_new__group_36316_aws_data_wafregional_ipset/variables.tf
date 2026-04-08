variable "name" {
  description = "Name of the WAF Regional IP set"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_wafregional_ipset, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_aws_wafregional_ipset, region must not be empty when specified."
  }
}