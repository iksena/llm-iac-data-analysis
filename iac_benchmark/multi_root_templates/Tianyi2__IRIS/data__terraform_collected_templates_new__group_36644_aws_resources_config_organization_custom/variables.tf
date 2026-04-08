variable "name" {
  description = "Name of the rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_config_organization_custom_policy_rule, name must not be empty."
  }
}

variable "policy_text" {
  description = "Policy definition containing the rule logic"
  type        = string

  validation {
    condition     = length(var.policy_text) > 0
    error_message = "resource_aws_config_organization_custom_policy_rule, policy_text must not be empty."
  }
}

variable "policy_runtime" {
  description = "Runtime system for policy rules"
  type        = string

  validation {
    condition     = length(var.policy_runtime) > 0
    error_message = "resource_aws_config_organization_custom_policy_rule, policy_runtime must not be empty."
  }
}

variable "trigger_types" {
  description = "List of notification types that trigger AWS Config to run an evaluation for the rule"
  type        = list(string)

  validation {
    condition = alltrue([
      for trigger_type in var.trigger_types :
      contains(["ConfigurationItemChangeNotification", "OversizedConfigurationItemChangeNotification"], trigger_type)
    ])
    error_message = "resource_aws_config_organization_custom_policy_rule, trigger_types must contain only valid values: ConfigurationItemChangeNotification, OversizedConfigurationItemChangeNotification."
  }

  validation {
    condition     = length(var.trigger_types) > 0
    error_message = "resource_aws_config_organization_custom_policy_rule, trigger_types must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the rule"
  type        = string
  default     = null
}

variable "debug_log_delivery_accounts" {
  description = "List of accounts that you can enable debug logging for"
  type        = list(string)
  default     = null
}

variable "excluded_accounts" {
  description = "List of AWS account identifiers to exclude from the rule"
  type        = list(string)
  default     = null
}

variable "input_parameters" {
  description = "A string in JSON format that is passed to the AWS Config Rule Lambda Function"
  type        = string
  default     = null
}

variable "maximum_execution_frequency" {
  description = "Maximum frequency with which AWS Config runs evaluations for a rule"
  type        = string
  default     = null

  validation {
    condition = var.maximum_execution_frequency == null || contains([
      "One_Hour", "Three_Hours", "Six_Hours", "Twelve_Hours", "TwentyFour_Hours"
    ], var.maximum_execution_frequency)
    error_message = "resource_aws_config_organization_custom_policy_rule, maximum_execution_frequency must be one of: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours."
  }
}

variable "resource_id_scope" {
  description = "Identifier of the AWS resource to evaluate"
  type        = string
  default     = null
}

variable "resource_types_scope" {
  description = "List of types of AWS resources to evaluate"
  type        = list(string)
  default     = null
}

variable "tag_key_scope" {
  description = "Tag key of AWS resources to evaluate"
  type        = string
  default     = null
}

variable "tag_value_scope" {
  description = "Tag value of AWS resources to evaluate"
  type        = string
  default     = null

  validation {
    condition     = var.tag_value_scope == null || var.tag_key_scope != null
    error_message = "resource_aws_config_organization_custom_policy_rule, tag_value_scope requires tag_key_scope to be configured."
  }
}