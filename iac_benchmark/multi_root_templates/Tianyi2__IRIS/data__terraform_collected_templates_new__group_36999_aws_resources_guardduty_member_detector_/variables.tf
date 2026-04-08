variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "detector_id" {
  description = "Amazon GuardDuty detector ID."
  type        = string

  validation {
    condition     = can(regex("^[0-9a-f]{32}$", var.detector_id))
    error_message = "resource_aws_guardduty_member_detector_feature, detector_id must be a valid GuardDuty detector ID (32 hexadecimal characters)."
  }
}

variable "account_id" {
  description = "Member account ID to be updated."
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_guardduty_member_detector_feature, account_id must be a valid 12-digit AWS account ID."
  }
}

variable "name" {
  description = "The name of the detector feature."
  type        = string

  validation {
    condition = contains([
      "S3_DATA_EVENTS",
      "EKS_AUDIT_LOGS",
      "EBS_MALWARE_PROTECTION",
      "RDS_LOGIN_EVENTS",
      "EKS_RUNTIME_MONITORING",
      "RUNTIME_MONITORING",
      "LAMBDA_NETWORK_LOGS"
    ], var.name)
    error_message = "resource_aws_guardduty_member_detector_feature, name must be one of: S3_DATA_EVENTS, EKS_AUDIT_LOGS, EBS_MALWARE_PROTECTION, RDS_LOGIN_EVENTS, EKS_RUNTIME_MONITORING, RUNTIME_MONITORING, LAMBDA_NETWORK_LOGS."
  }
}

variable "status" {
  description = "The status of the detector feature."
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.status)
    error_message = "resource_aws_guardduty_member_detector_feature, status must be either ENABLED or DISABLED."
  }
}

variable "additional_configuration" {
  description = "Additional feature configuration block."
  type = object({
    name   = string
    status = string
  })
  default = null

  validation {
    condition = var.additional_configuration == null || contains([
      "EKS_ADDON_MANAGEMENT",
      "ECS_FARGATE_AGENT_MANAGEMENT"
    ], var.additional_configuration.name)
    error_message = "resource_aws_guardduty_member_detector_feature, additional_configuration.name must be either EKS_ADDON_MANAGEMENT or ECS_FARGATE_AGENT_MANAGEMENT."
  }

  validation {
    condition = var.additional_configuration == null || contains([
      "ENABLED",
      "DISABLED"
    ], var.additional_configuration.status)
    error_message = "resource_aws_guardduty_member_detector_feature, additional_configuration.status must be either ENABLED or DISABLED."
  }
}