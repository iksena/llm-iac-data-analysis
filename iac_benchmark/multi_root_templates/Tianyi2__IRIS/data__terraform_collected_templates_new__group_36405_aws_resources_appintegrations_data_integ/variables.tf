variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Specifies the description of the Data Integration."
  type        = string
  default     = null
}

variable "kms_key" {
  description = "Specifies the KMS key Amazon Resource Name (ARN) for the Data Integration."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:kms:", var.kms_key))
    error_message = "resource_aws_appintegrations_data_integration, kms_key must be a valid KMS key ARN starting with 'arn:aws:kms:'."
  }
}

variable "name" {
  description = "Specifies the name of the Data Integration."
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 255
    error_message = "resource_aws_appintegrations_data_integration, name must be between 1 and 255 characters."
  }
}

variable "schedule_config" {
  description = "A block that defines the name of the data and how often it should be pulled from the source."
  type = object({
    first_execution_from = string
    object               = string
    schedule_expression  = string
  })

  validation {
    condition     = length(var.schedule_config.first_execution_from) > 0
    error_message = "resource_aws_appintegrations_data_integration, schedule_config.first_execution_from is required and cannot be empty."
  }

  validation {
    condition     = length(var.schedule_config.object) > 0
    error_message = "resource_aws_appintegrations_data_integration, schedule_config.object is required and cannot be empty."
  }

  validation {
    condition     = length(var.schedule_config.schedule_expression) > 0 && can(regex("^rate\\(", var.schedule_config.schedule_expression))
    error_message = "resource_aws_appintegrations_data_integration, schedule_config.schedule_expression must be a valid rate expression starting with 'rate('."
  }
}

variable "source_uri" {
  description = "Specifies the URI of the data source. Create an AppFlow Connector Profile and reference the name of the profile in the URL."
  type        = string

  validation {
    condition     = length(var.source_uri) > 0
    error_message = "resource_aws_appintegrations_data_integration, source_uri is required and cannot be empty."
  }
}

variable "tags" {
  description = "Tags to apply to the Data Integration."
  type        = map(string)
  default     = {}
}