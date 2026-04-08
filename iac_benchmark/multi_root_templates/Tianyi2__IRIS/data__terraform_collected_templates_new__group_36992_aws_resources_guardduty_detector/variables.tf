variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "enable" {
  description = "Enable monitoring and feedback reporting. Setting to false is equivalent to 'suspending' GuardDuty. Defaults to true."
  type        = bool
  default     = true
}

variable "finding_publishing_frequency" {
  description = "Specifies the frequency of notifications sent for subsequent finding occurrences. If the detector is a GuardDuty member account, the value is determined by the GuardDuty primary account and cannot be modified, otherwise defaults to SIX_HOURS. For standalone and GuardDuty primary accounts, it must be configured in Terraform to enable drift detection. Valid values for standalone and primary accounts: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS."
  type        = string
  default     = "SIX_HOURS"

  validation {
    condition     = contains(["FIFTEEN_MINUTES", "ONE_HOUR", "SIX_HOURS"], var.finding_publishing_frequency)
    error_message = "resource_aws_guardduty_detector, finding_publishing_frequency must be one of: FIFTEEN_MINUTES, ONE_HOUR, SIX_HOURS."
  }
}

variable "datasources" {
  description = "Describes which data sources will be enabled for the detector. This argument is deprecated - use aws_guardduty_detector_feature resources instead."
  type = object({
    s3_logs = optional(object({
      enable = bool
    }))
    kubernetes = optional(object({
      audit_logs = object({
        enable = bool
      })
    }))
    malware_protection = optional(object({
      scan_ec2_instance_with_findings = object({
        ebs_volumes = object({
          enable = bool
        })
      })
    }))
  })
  default = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}