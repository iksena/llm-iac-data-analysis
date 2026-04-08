variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_config_config_rule, name must not be empty."
  }
}

variable "description" {
  description = "Description of the rule"
  type        = string
  default     = null
}

variable "evaluation_mode" {
  description = "The modes the Config rule can be evaluated in."
  type = list(object({
    mode = string
  }))
  default = null

  validation {
    condition = var.evaluation_mode == null ? true : alltrue([
      for mode in var.evaluation_mode : contains(["DETECTIVE", "PROACTIVE"], mode.mode)
    ])
    error_message = "resource_aws_config_config_rule, evaluation_mode.mode must be either 'DETECTIVE' or 'PROACTIVE'."
  }
}

variable "input_parameters" {
  description = "A string in JSON format that is passed to the AWS Config rule Lambda function."
  type        = string
  default     = null
}

variable "maximum_execution_frequency" {
  description = "The maximum frequency with which AWS Config runs evaluations for a rule."
  type        = string
  default     = null

  validation {
    condition = var.maximum_execution_frequency == null ? true : contains([
      "One_Hour", "Three_Hours", "Six_Hours", "Twelve_Hours", "TwentyFour_Hours"
    ], var.maximum_execution_frequency)
    error_message = "resource_aws_config_config_rule, maximum_execution_frequency must be one of: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours."
  }
}

variable "scope" {
  description = "Scope defines which resources can trigger an evaluation for the rule."
  type = object({
    compliance_resource_id    = optional(string)
    compliance_resource_types = optional(list(string))
    tag_key                   = optional(string)
    tag_value                 = optional(string)
  })
  default = null

  validation {
    condition = var.scope == null ? true : (
      var.scope.tag_value != null ? var.scope.tag_key != null : true
    )
    error_message = "resource_aws_config_config_rule, scope.tag_key is required when scope.tag_value is specified."
  }

  validation {
    condition = var.scope == null ? true : (
      var.scope.compliance_resource_id != null ? (
        var.scope.compliance_resource_types != null && length(var.scope.compliance_resource_types) == 1
      ) : true
    )
    error_message = "resource_aws_config_config_rule, scope.compliance_resource_types must contain exactly one resource type when scope.compliance_resource_id is specified."
  }
}

variable "rule_source" {
  description = "Source specifies the rule owner, the rule identifier, and the notifications that cause the function to evaluate your AWS resources."
  type = object({
    owner             = string
    source_identifier = optional(string)
    source_detail = optional(list(object({
      event_source                = optional(string)
      maximum_execution_frequency = optional(string)
      message_type                = optional(string)
    })))
    custom_policy_details = optional(object({
      enable_debug_log_delivery = optional(bool)
      policy_runtime            = string
      policy_text               = string
    }))
  })

  validation {
    condition     = contains(["AWS", "CUSTOM_LAMBDA", "CUSTOM_POLICY"], var.rule_source.owner)
    error_message = "resource_aws_config_config_rule, source.owner must be one of: AWS, CUSTOM_LAMBDA, CUSTOM_POLICY."
  }

  validation {
    condition     = var.rule_source.owner == "CUSTOM_POLICY" ? var.rule_source.custom_policy_details != null : true
    error_message = "resource_aws_config_config_rule, source.custom_policy_details is required when source.owner is CUSTOM_POLICY."
  }

  validation {
    condition = var.rule_source.source_detail == null ? true : alltrue([
      for detail in var.rule_source.source_detail :
      detail.message_type == null ? true : contains([
        "ConfigurationItemChangeNotification",
        "OversizedConfigurationItemChangeNotification",
        "ScheduledNotification",
        "ConfigurationSnapshotDeliveryCompleted"
      ], detail.message_type)
    ])
    error_message = "resource_aws_config_config_rule, source.source_detail.message_type must be one of: ConfigurationItemChangeNotification, OversizedConfigurationItemChangeNotification, ScheduledNotification, ConfigurationSnapshotDeliveryCompleted."
  }

  validation {
    condition = var.rule_source.source_detail == null ? true : alltrue([
      for detail in var.rule_source.source_detail :
      detail.maximum_execution_frequency == null ? true : contains([
        "One_Hour", "Three_Hours", "Six_Hours", "Twelve_Hours", "TwentyFour_Hours"
      ], detail.maximum_execution_frequency)
    ])
    error_message = "resource_aws_config_config_rule, source.source_detail.maximum_execution_frequency must be one of: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours."
  }

  validation {
    condition = var.rule_source.source_detail == null ? true : alltrue([
      for detail in var.rule_source.source_detail :
      detail.maximum_execution_frequency != null ? detail.message_type == "ScheduledNotification" : true
    ])
    error_message = "resource_aws_config_config_rule, source.source_detail.message_type must be ScheduledNotification when source.source_detail.maximum_execution_frequency is specified."
  }

  validation {
    condition = var.rule_source.source_detail == null ? true : alltrue([
      for detail in var.rule_source.source_detail :
      detail.event_source == null ? true : detail.event_source == "aws.config"
    ])
    error_message = "resource_aws_config_config_rule, source.source_detail.event_source must be aws.config when specified."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}