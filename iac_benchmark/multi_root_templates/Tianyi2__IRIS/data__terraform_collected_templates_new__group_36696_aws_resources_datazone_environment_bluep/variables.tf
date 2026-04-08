variable "domain_id" {
  description = "ID of the Domain"
  type        = string

  validation {
    condition     = length(var.domain_id) > 0
    error_message = "resource_aws_datazone_environment_blueprint_configuration, domain_id must not be empty."
  }
}

variable "environment_blueprint_id" {
  description = "ID of the Environment Blueprint"
  type        = string

  validation {
    condition     = length(var.environment_blueprint_id) > 0
    error_message = "resource_aws_datazone_environment_blueprint_configuration, environment_blueprint_id must not be empty."
  }
}

variable "enabled_regions" {
  description = "Regions in which the blueprint is enabled"
  type        = list(string)

  validation {
    condition     = length(var.enabled_regions) > 0
    error_message = "resource_aws_datazone_environment_blueprint_configuration, enabled_regions must contain at least one region."
  }

  validation {
    condition = alltrue([
      for region in var.enabled_regions : can(regex("^[a-z0-9-]+$", region))
    ])
    error_message = "resource_aws_datazone_environment_blueprint_configuration, enabled_regions must contain valid AWS region names."
  }
}

variable "manage_access_role_arn" {
  description = "ARN of the manage access role with which this blueprint is created"
  type        = string
  default     = null

  validation {
    condition     = var.manage_access_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.manage_access_role_arn))
    error_message = "resource_aws_datazone_environment_blueprint_configuration, manage_access_role_arn must be a valid IAM role ARN."
  }
}

variable "provisioning_role_arn" {
  description = "ARN of the provisioning role with which this blueprint is created"
  type        = string
  default     = null

  validation {
    condition     = var.provisioning_role_arn == null || can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.provisioning_role_arn))
    error_message = "resource_aws_datazone_environment_blueprint_configuration, provisioning_role_arn must be a valid IAM role ARN."
  }
}

variable "regional_parameters" {
  description = "Parameters for each region in which the blueprint is enabled"
  type        = map(map(string))
  default     = null

  validation {
    condition = var.regional_parameters == null || alltrue([
      for region, params in var.regional_parameters : can(regex("^[a-z0-9-]+$", region))
    ])
    error_message = "resource_aws_datazone_environment_blueprint_configuration, regional_parameters keys must be valid AWS region names."
  }
}