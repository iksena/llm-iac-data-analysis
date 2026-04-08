variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the WAF rule group."
  type        = string
  default     = null
}

variable "metric_name" {
  description = "Name of the WAF rule group."
  type        = string
  default     = null

  validation {
    condition     = var.name != null || var.metric_name != null
    error_message = "data_aws_wafregional_subscribed_rule_group, name or metric_name: At least one of 'name' or 'metric_name' must be configured."
  }
}