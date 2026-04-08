variable "lambda_function_arn" {
  description = "Amazon Resource Name (ARN) of the rule Lambda Function"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:lambda:[a-z0-9-]+:[0-9]{12}:function:", var.lambda_function_arn))
    error_message = "resource_aws_config_organization_custom_rule, lambda_function_arn must be a valid Lambda function ARN."
  }
}

variable "name" {
  description = "The name of the rule"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 128
    error_message = "resource_aws_config_organization_custom_rule, name must be between 1 and 128 characters."
  }
}

variable "trigger_types" {
  description = "List of notification types that trigger AWS Config to run an evaluation for the rule"
  type        = list(string)

  validation {
    condition = length(var.trigger_types) > 0 && alltrue([
      for trigger in var.trigger_types : contains([
        "ConfigurationItemChangeNotification",
        "OversizedConfigurationItemChangeNotification",
        "ScheduledNotification"
      ], trigger)
    ])
    error_message = "resource_aws_config_organization_custom_rule, trigger_types must contain at least one valid trigger type: ConfigurationItemChangeNotification, OversizedConfigurationItemChangeNotification, or ScheduledNotification."
  }
}

variable "description" {
  description = "Description of the rule"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 256
    error_message = "resource_aws_config_organization_custom_rule, description must not exceed 256 characters."
  }
}

variable "excluded_accounts" {
  description = "List of AWS account identifiers to exclude from the rule"
  type        = list(string)
  default     = null

  validation {
    condition = var.excluded_accounts == null || alltrue([
      for account in var.excluded_accounts : can(regex("^[0-9]{12}$", account))
    ])
    error_message = "resource_aws_config_organization_custom_rule, excluded_accounts must contain valid 12-digit AWS account IDs."
  }
}

variable "input_parameters" {
  description = "A string in JSON format that is passed to the AWS Config Rule Lambda Function"
  type        = string
  default     = null

  validation {
    condition     = var.input_parameters == null || can(jsondecode(var.input_parameters))
    error_message = "resource_aws_config_organization_custom_rule, input_parameters must be valid JSON string."
  }
}

variable "maximum_execution_frequency" {
  description = "The maximum frequency with which AWS Config runs evaluations for a rule, if the rule is triggered at a periodic frequency"
  type        = string
  default     = null

  validation {
    condition = var.maximum_execution_frequency == null || contains([
      "One_Hour",
      "Three_Hours",
      "Six_Hours",
      "Twelve_Hours",
      "TwentyFour_Hours"
    ], var.maximum_execution_frequency)
    error_message = "resource_aws_config_organization_custom_rule, maximum_execution_frequency must be one of: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, or TwentyFour_Hours."
  }
}

variable "resource_id_scope" {
  description = "Identifier of the AWS resource to evaluate"
  type        = string
  default     = null

  validation {
    condition     = var.resource_id_scope == null || length(var.resource_id_scope) > 0
    error_message = "resource_aws_config_organization_custom_rule, resource_id_scope must not be empty if specified."
  }
}

variable "resource_types_scope" {
  description = "List of types of AWS resources to evaluate"
  type        = list(string)
  default     = null

  validation {
    condition = var.resource_types_scope == null || (
      length(var.resource_types_scope) > 0 && alltrue([
        for resource_type in var.resource_types_scope : length(resource_type) > 0
      ])
    )
    error_message = "resource_aws_config_organization_custom_rule, resource_types_scope must contain at least one non-empty resource type."
  }
}

variable "tag_key_scope" {
  description = "Tag key of AWS resources to evaluate"
  type        = string
  default     = null

  validation {
    condition     = var.tag_key_scope == null || length(var.tag_key_scope) > 0
    error_message = "resource_aws_config_organization_custom_rule, tag_key_scope must not be empty if specified."
  }
}

variable "tag_value_scope" {
  description = "Tag value of AWS resources to evaluate"
  type        = string
  default     = null

  validation {
    condition     = (var.tag_value_scope == null && var.tag_key_scope == null) || (var.tag_value_scope != null && var.tag_key_scope != null)
    error_message = "resource_aws_config_organization_custom_rule, tag_value_scope requires tag_key_scope to be configured."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
    update = optional(string, "5m")
  })
  default = null

  validation {
    condition = var.timeouts == null || alltrue([
      for timeout in [var.timeouts.create, var.timeouts.delete, var.timeouts.update] :
      timeout == null || can(regex("^[0-9]+[smh]$", timeout))
    ])
    error_message = "resource_aws_config_organization_custom_rule, timeouts values must be valid duration strings (e.g., '5m', '10s', '1h')."
  }
}