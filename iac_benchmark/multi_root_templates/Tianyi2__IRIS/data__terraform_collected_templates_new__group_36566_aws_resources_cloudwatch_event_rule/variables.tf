variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the rule. If omitted, Terraform will assign a random, unique name. Conflicts with name_prefix."
  type        = string
  default     = null

}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name. Must be 38 characters or less."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || length(var.name_prefix) <= 38
    error_message = "resource_aws_cloudwatch_event_rule, name_prefix: Must be 38 characters or less."
  }

}

variable "schedule_expression" {
  description = "The scheduling expression. For example, cron(0 20 * * ? *) or rate(5 minutes). At least one of schedule_expression or event_pattern is required. Can only be used on the default event bus."
  type        = string
  default     = null


}

variable "event_bus_name" {
  description = "The name or ARN of the event bus to associate with this rule. If you omit this, the default event bus is used."
  type        = string
  default     = null
}

variable "event_pattern" {
  description = "The event pattern described as a JSON object. At least one of schedule_expression or event_pattern is required. The event pattern size is 2048 by default but adjustable up to 4096 characters."
  type        = string
  default     = null

}

variable "force_destroy" {
  description = "Used to delete managed rules created by AWS. Defaults to false."
  type        = bool
  default     = false
}

variable "description" {
  description = "The description of the rule."
  type        = string
  default     = null
}

variable "role_arn" {
  description = "The Amazon Resource Name (ARN) associated with the role that is used for target invocation."
  type        = string
  default     = null
}

variable "is_enabled" {
  description = "Whether the rule should be enabled. Defaults to true. Conflicts with state. DEPRECATED: Use state instead."
  type        = bool
  default     = null

}

variable "state" {
  description = "State of the rule. Valid values are DISABLED, ENABLED, and ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS. Defaults to ENABLED. Conflicts with is_enabled."
  type        = string
  default     = "ENABLED"

  validation {
    condition     = var.state == null || contains(["DISABLED", "ENABLED", "ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS"], var.state)
    error_message = "resource_aws_cloudwatch_event_rule, state: Valid values are DISABLED, ENABLED, and ENABLED_WITH_ALL_CLOUDTRAIL_MANAGEMENT_EVENTS."
  }


}

variable "tags" {
  description = "A map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}