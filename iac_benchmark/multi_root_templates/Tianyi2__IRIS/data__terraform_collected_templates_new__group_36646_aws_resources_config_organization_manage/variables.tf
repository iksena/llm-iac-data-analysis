variable "name" {
  description = "The name of the rule"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_config_organization_managed_rule, name must not be empty."
  }
}

variable "rule_identifier" {
  description = "Identifier of an available AWS Config Managed Rule to call"
  type        = string

  validation {
    condition     = length(var.rule_identifier) > 0
    error_message = "resource_aws_config_organization_managed_rule, rule_identifier must not be empty."
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

variable "excluded_accounts" {
  description = "List of AWS account identifiers to exclude from the rule"
  type        = list(string)
  default     = null

  validation {
    condition = var.excluded_accounts == null ? true : alltrue([
      for account in var.excluded_accounts : can(regex("^[0-9]{12}$", account))
    ])
    error_message = "resource_aws_config_organization_managed_rule, excluded_accounts must contain valid 12-digit AWS account IDs."
  }
}

variable "input_parameters" {
  description = "A string in JSON format that is passed to the AWS Config Rule Lambda Function"
  type        = string
  default     = null

  validation {
    condition     = var.input_parameters == null ? true : can(jsondecode(var.input_parameters))
    error_message = "resource_aws_config_organization_managed_rule, input_parameters must be valid JSON."
  }
}

variable "maximum_execution_frequency" {
  description = "The maximum frequency with which AWS Config runs evaluations for a rule"
  type        = string
  default     = null

  validation {
    condition = var.maximum_execution_frequency == null ? true : contains([
      "One_Hour", "Three_Hours", "Six_Hours", "Twelve_Hours", "TwentyFour_Hours"
    ], var.maximum_execution_frequency)
    error_message = "resource_aws_config_organization_managed_rule, maximum_execution_frequency must be one of: One_Hour, Three_Hours, Six_Hours, Twelve_Hours, TwentyFour_Hours."
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

  validation {
    condition = var.resource_types_scope == null ? true : alltrue([
      for resource_type in var.resource_types_scope : length(resource_type) > 0
    ])
    error_message = "resource_aws_config_organization_managed_rule, resource_types_scope must not contain empty strings."
  }
}

variable "tag_key_scope" {
  description = "Tag key of AWS resources to evaluate"
  type        = string
  default     = null

  validation {
    condition     = var.tag_key_scope != null && var.tag_value_scope == null ? false : true
    error_message = "resource_aws_config_organization_managed_rule, tag_key_scope requires tag_value_scope to be configured."
  }
}

variable "tag_value_scope" {
  description = "Tag value of AWS resources to evaluate"
  type        = string
  default     = null
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "5m")
    update = optional(string, "5m")
  })
  default = null
}