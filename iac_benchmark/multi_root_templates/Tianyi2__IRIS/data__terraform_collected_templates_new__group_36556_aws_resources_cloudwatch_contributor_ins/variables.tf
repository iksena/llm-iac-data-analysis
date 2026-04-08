variable "rule_definition" {
  description = "Definition of the rule, as a JSON object. For details on the valid syntax, see Contributor Insights Rule Syntax."
  type        = string

  validation {
    condition     = can(jsondecode(var.rule_definition))
    error_message = "resource_aws_cloudwatch_contributor_insight_rule, rule_definition must be a valid JSON string."
  }
}

variable "rule_name" {
  description = "Unique name of the rule."
  type        = string

  validation {
    condition     = length(var.rule_name) > 0
    error_message = "resource_aws_cloudwatch_contributor_insight_rule, rule_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "rule_state" {
  description = "State of the rule. Valid values are ENABLED and DISABLED."
  type        = string
  default     = null

  validation {
    condition     = var.rule_state == null || contains(["ENABLED", "DISABLED"], var.rule_state)
    error_message = "resource_aws_cloudwatch_contributor_insight_rule, rule_state must be either 'ENABLED' or 'DISABLED'."
  }
}