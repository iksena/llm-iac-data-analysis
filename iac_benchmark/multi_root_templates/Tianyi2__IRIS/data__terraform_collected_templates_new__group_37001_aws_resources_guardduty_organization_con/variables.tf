variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "auto_enable_organization_members" {
  description = "Indicates the auto-enablement configuration of GuardDuty for the member accounts in the organization. Valid values are ALL, NEW, NONE."
  type        = string

  validation {
    condition     = contains(["ALL", "NEW", "NONE"], var.auto_enable_organization_members)
    error_message = "resource_aws_guardduty_organization_configuration, auto_enable_organization_members must be one of: ALL, NEW, NONE."
  }
}

variable "detector_id" {
  description = "The detector ID of the GuardDuty account."
  type        = string

  validation {
    condition     = length(var.detector_id) > 0
    error_message = "resource_aws_guardduty_organization_configuration, detector_id cannot be empty."
  }
}

variable "datasources" {
  description = "Configuration for the collected datasources. Deprecated in favor of aws_guardduty_organization_configuration_feature resources."
  type = object({
    s3_logs = optional(object({
      auto_enable = optional(bool, false)
    }))
    kubernetes = optional(object({
      audit_logs = object({
        enable = optional(bool, true)
      })
    }))
    malware_protection = optional(object({
      scan_ec2_instance_with_findings = object({
        ebs_volumes = object({
          auto_enable = optional(bool, true)
        })
      })
    }))
  })
  default = null

  validation {
    condition = var.datasources == null || (
      var.datasources.kubernetes == null ||
      var.datasources.kubernetes.audit_logs != null
    )
    error_message = "resource_aws_guardduty_organization_configuration, datasources.kubernetes.audit_logs is required when kubernetes is specified."
  }

  validation {
    condition = var.datasources == null || (
      var.datasources.malware_protection == null ||
      var.datasources.malware_protection.scan_ec2_instance_with_findings != null
    )
    error_message = "resource_aws_guardduty_organization_configuration, datasources.malware_protection.scan_ec2_instance_with_findings is required when malware_protection is specified."
  }

  validation {
    condition = var.datasources == null || (
      var.datasources.malware_protection == null ||
      var.datasources.malware_protection.scan_ec2_instance_with_findings == null ||
      var.datasources.malware_protection.scan_ec2_instance_with_findings.ebs_volumes != null
    )
    error_message = "resource_aws_guardduty_organization_configuration, datasources.malware_protection.scan_ec2_instance_with_findings.ebs_volumes is required when scan_ec2_instance_with_findings is specified."
  }
}