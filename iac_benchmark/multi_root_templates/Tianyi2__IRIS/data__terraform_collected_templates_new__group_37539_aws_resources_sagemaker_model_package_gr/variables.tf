variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_sagemaker_model_package_group_policy, region must be a valid AWS region name or null."
  }
}

variable "model_package_group_name" {
  description = "The name of the model package group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,63}$", var.model_package_group_name))
    error_message = "resource_aws_sagemaker_model_package_group_policy, model_package_group_name must be between 1 and 63 characters, containing only letters, numbers, and hyphens."
  }
}

variable "resource_policy" {
  description = "The resource policy for the model package group."
  type        = string

  validation {
    condition     = can(jsondecode(var.resource_policy))
    error_message = "resource_aws_sagemaker_model_package_group_policy, resource_policy must be a valid JSON string."
  }
}