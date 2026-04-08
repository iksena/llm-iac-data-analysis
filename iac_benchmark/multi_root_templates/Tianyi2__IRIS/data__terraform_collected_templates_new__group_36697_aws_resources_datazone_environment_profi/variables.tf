variable "aws_account_id" {
  description = "Id of the AWS account being used"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.aws_account_id))
    error_message = "resource_aws_datazone_environment_profile, aws_account_id must be a 12-digit AWS account ID."
  }
}

variable "aws_account_region" {
  description = "Desired region for environment profile"
  type        = string

  validation {
    condition     = length(var.aws_account_region) > 0
    error_message = "resource_aws_datazone_environment_profile, aws_account_region cannot be empty."
  }
}

variable "domain_identifier" {
  description = "Domain Identifier for environment profile"
  type        = string

  validation {
    condition     = length(var.domain_identifier) > 0
    error_message = "resource_aws_datazone_environment_profile, domain_identifier cannot be empty."
  }
}

variable "name" {
  description = "Name of the environment profile"
  type        = string

  validation {
    condition     = length(var.name) > 0 && length(var.name) <= 64
    error_message = "resource_aws_datazone_environment_profile, name must be between 1 and 64 characters."
  }
}

variable "environment_blueprint_identifier" {
  description = "ID of the blueprint which the environment will be created with"
  type        = string

  validation {
    condition     = length(var.environment_blueprint_identifier) > 0
    error_message = "resource_aws_datazone_environment_profile, environment_blueprint_identifier cannot be empty."
  }
}

variable "project_identifier" {
  description = "Project identifier for environment profile"
  type        = string

  validation {
    condition     = length(var.project_identifier) > 0
    error_message = "resource_aws_datazone_environment_profile, project_identifier cannot be empty."
  }
}

variable "description" {
  description = "Description of environment profile"
  type        = string
  default     = null
}

variable "user_parameters" {
  description = "Array of user parameters of the environment profile"
  type = list(object({
    name  = string
    value = string
  }))
  default = []

  validation {
    condition = alltrue([
      for param in var.user_parameters :
      length(param.name) > 0 && length(param.value) > 0
    ])
    error_message = "resource_aws_datazone_environment_profile, user_parameters name and value cannot be empty."
  }
}