variable "application_id" {
  description = "Application ID. Must be between 4 and 7 characters in length."
  type        = string

  validation {
    condition     = length(var.application_id) >= 4 && length(var.application_id) <= 7
    error_message = "resource_aws_appconfig_deployment, application_id must be between 4 and 7 characters in length."
  }
}

variable "configuration_profile_id" {
  description = "Configuration profile ID. Must be between 4 and 7 characters in length."
  type        = string

  validation {
    condition     = length(var.configuration_profile_id) >= 4 && length(var.configuration_profile_id) <= 7
    error_message = "resource_aws_appconfig_deployment, configuration_profile_id must be between 4 and 7 characters in length."
  }
}

variable "configuration_version" {
  description = "Configuration version to deploy. Can be at most 1024 characters."
  type        = string

  validation {
    condition     = length(var.configuration_version) <= 1024
    error_message = "resource_aws_appconfig_deployment, configuration_version can be at most 1024 characters."
  }
}

variable "deployment_strategy_id" {
  description = "Deployment strategy ID or name of a predefined deployment strategy."
  type        = string
}

variable "environment_id" {
  description = "Environment ID. Must be between 4 and 7 characters in length."
  type        = string

  validation {
    condition     = length(var.environment_id) >= 4 && length(var.environment_id) <= 7
    error_message = "resource_aws_appconfig_deployment, environment_id must be between 4 and 7 characters in length."
  }
}

variable "description" {
  description = "Description of the deployment. Can be at most 1024 characters."
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_appconfig_deployment, description can be at most 1024 characters."
  }
}

variable "kms_key_identifier" {
  description = "The KMS key identifier (key ID, key alias, or key ARN). AppConfig uses this to encrypt the configuration data using a customer managed key."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}