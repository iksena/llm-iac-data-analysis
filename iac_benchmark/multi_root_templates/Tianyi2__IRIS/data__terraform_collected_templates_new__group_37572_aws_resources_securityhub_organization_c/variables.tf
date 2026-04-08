variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auto_enable" {
  description = "Whether to automatically enable Security Hub for new accounts in the organization."
  type        = bool

  validation {
    condition     = var.organization_configuration == null || var.organization_configuration.configuration_type != "CENTRAL" || var.auto_enable == false
    error_message = "resource_aws_securityhub_organization_configuration, auto_enable must be set to false when using CENTRAL configuration_type."
  }
}

variable "auto_enable_standards" {
  description = "Whether to automatically enable Security Hub default standards for new member accounts in the organization. By default, this parameter is equal to DEFAULT, and new member accounts are automatically enabled with default Security Hub standards. To opt out of enabling default standards for new member accounts, set this parameter equal to NONE."
  type        = string
  default     = "DEFAULT"

  validation {
    condition     = contains(["DEFAULT", "NONE"], var.auto_enable_standards)
    error_message = "resource_aws_securityhub_organization_configuration, auto_enable_standards must be either 'DEFAULT' or 'NONE'."
  }

  validation {
    condition     = var.organization_configuration == null || var.organization_configuration.configuration_type != "CENTRAL" || var.auto_enable_standards == "NONE"
    error_message = "resource_aws_securityhub_organization_configuration, auto_enable_standards must be set to 'NONE' when using CENTRAL configuration_type."
  }
}

variable "organization_configuration" {
  description = "Provides information about the way an organization is configured in Security Hub."
  type = object({
    configuration_type = string
  })
  default = null

  validation {
    condition     = var.organization_configuration == null || contains(["LOCAL", "CENTRAL"], var.organization_configuration.configuration_type)
    error_message = "resource_aws_securityhub_organization_configuration, configuration_type must be either 'LOCAL' or 'CENTRAL'."
  }
}

variable "create_timeout" {
  description = "Timeout for creating the resource."
  type        = string
  default     = "180s"
}

variable "update_timeout" {
  description = "Timeout for updating the resource."
  type        = string
  default     = "180s"
}

variable "delete_timeout" {
  description = "Timeout for deleting the resource."
  type        = string
  default     = "180s"
}