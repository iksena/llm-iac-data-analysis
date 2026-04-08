variable "domain_identifier" {
  description = "The ID of the domain where the environment exists"
  type        = string

  validation {
    condition     = can(regex("^dzd_[a-z0-9]{13}$", var.domain_identifier))
    error_message = "resource_aws_datazone_environment, domain_identifier must be a valid DataZone domain ID starting with 'dzd_' followed by 13 alphanumeric characters."
  }
}

variable "name" {
  description = "The name of the environment"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_datazone_environment, name must be between 1 and 64 characters long."
  }
}

variable "profile_identifier" {
  description = "The ID of the profile with which the environment is created"
  type        = string

  validation {
    condition     = length(var.profile_identifier) > 0
    error_message = "resource_aws_datazone_environment, profile_identifier cannot be empty."
  }
}

variable "project_identifier" {
  description = "The ID of the project where the environment exists"
  type        = string

  validation {
    condition     = length(var.project_identifier) > 0
    error_message = "resource_aws_datazone_environment, project_identifier cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "account_identifier" {
  description = "The ID of the Amazon Web Services account where the environment exists"
  type        = string
  default     = null

  validation {
    condition     = var.account_identifier == null || can(regex("^[0-9]{12}$", var.account_identifier))
    error_message = "resource_aws_datazone_environment, account_identifier must be a 12-digit AWS account ID."
  }
}

variable "account_region" {
  description = "The Amazon Web Services region where the environment exists"
  type        = string
  default     = null

  validation {
    condition     = var.account_region == null || can(regex("^[a-z0-9-]+$", var.account_region))
    error_message = "resource_aws_datazone_environment, account_region must be a valid AWS region format."
  }
}

variable "blueprint_identifier" {
  description = "The blueprint with which the environment is created"
  type        = string
  default     = null
}

variable "description" {
  description = "The description of the environment"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 2048
    error_message = "resource_aws_datazone_environment, description must be 2048 characters or less."
  }
}

variable "glossary_terms" {
  description = "The business glossary terms that can be used in this environment"
  type        = list(string)
  default     = null
}

variable "user_parameters" {
  description = "The user parameters that are used in the environment"
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition     = alltrue([for param in var.user_parameters : length(param.name) > 0])
    error_message = "resource_aws_datazone_environment, user_parameters name cannot be empty."
  }

  validation {
    condition     = alltrue([for param in var.user_parameters : length(param.value) > 0])
    error_message = "resource_aws_datazone_environment, user_parameters value cannot be empty."
  }
}

variable "create_timeout" {
  description = "Timeout for create operation"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.create_timeout))
    error_message = "resource_aws_datazone_environment, create_timeout must be a valid duration (e.g., '10m', '1h')."
  }
}

variable "update_timeout" {
  description = "Timeout for update operation"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.update_timeout))
    error_message = "resource_aws_datazone_environment, update_timeout must be a valid duration (e.g., '10m', '1h')."
  }
}

variable "delete_timeout" {
  description = "Timeout for delete operation"
  type        = string
  default     = "10m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.delete_timeout))
    error_message = "resource_aws_datazone_environment, delete_timeout must be a valid duration (e.g., '10m', '1h')."
  }
}