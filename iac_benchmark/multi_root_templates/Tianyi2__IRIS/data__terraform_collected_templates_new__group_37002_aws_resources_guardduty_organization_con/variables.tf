variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auto_enable" {
  description = "The status of the feature that is configured for the member accounts within the organization."
  type        = string

  validation {
    condition     = contains(["NEW", "ALL", "NONE"], var.auto_enable)
    error_message = "resource_aws_guardduty_organization_configuration_feature, auto_enable must be one of: NEW, ALL, NONE."
  }
}

variable "detector_id" {
  description = "The ID of the detector that configures the delegated administrator."
  type        = string
}

variable "name" {
  description = "The name of the feature that will be configured for the organization."
  type        = string

  validation {
    condition     = contains(["S3_DATA_EVENTS", "EKS_AUDIT_LOGS", "EBS_MALWARE_PROTECTION", "RDS_LOGIN_EVENTS", "EKS_RUNTIME_MONITORING", "LAMBDA_NETWORK_LOGS", "RUNTIME_MONITORING"], var.name)
    error_message = "resource_aws_guardduty_organization_configuration_feature, name must be one of: S3_DATA_EVENTS, EKS_AUDIT_LOGS, EBS_MALWARE_PROTECTION, RDS_LOGIN_EVENTS, EKS_RUNTIME_MONITORING, LAMBDA_NETWORK_LOGS, RUNTIME_MONITORING."
  }
}

variable "additional_configuration" {
  description = "Additional feature configuration block for features EKS_RUNTIME_MONITORING or RUNTIME_MONITORING."
  type = list(object({
    auto_enable = string
    name        = string
  }))
  default = []

  validation {
    condition = alltrue([
      for config in var.additional_configuration :
      contains(["NEW", "ALL", "NONE"], config.auto_enable)
    ])
    error_message = "resource_aws_guardduty_organization_configuration_feature, additional_configuration.auto_enable must be one of: NEW, ALL, NONE."
  }

  validation {
    condition = alltrue([
      for config in var.additional_configuration :
      contains(["EKS_ADDON_MANAGEMENT", "ECS_FARGATE_AGENT_MANAGEMENT", "EC2_AGENT_MANAGEMENT"], config.name)
    ])
    error_message = "resource_aws_guardduty_organization_configuration_feature, additional_configuration.name must be one of: EKS_ADDON_MANAGEMENT, ECS_FARGATE_AGENT_MANAGEMENT, EC2_AGENT_MANAGEMENT."
  }
}