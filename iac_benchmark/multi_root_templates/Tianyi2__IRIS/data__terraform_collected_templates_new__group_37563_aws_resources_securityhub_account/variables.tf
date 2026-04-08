variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "enable_default_standards" {
  description = "Whether to enable the security standards that Security Hub has designated as automatically enabled including: AWS Foundational Security Best Practices v1.0.0 and CIS AWS Foundations Benchmark v1.2.0."
  type        = bool
  default     = true
}

variable "control_finding_generator" {
  description = "Updates whether the calling account has consolidated control findings turned on. If the value for this field is set to SECURITY_CONTROL, Security Hub generates a single finding for a control check even when the check applies to multiple enabled standards. If the value for this field is set to STANDARD_CONTROL, Security Hub generates separate findings for a control check when the check applies to multiple enabled standards."
  type        = string
  default     = null

  validation {
    condition     = var.control_finding_generator == null || contains(["SECURITY_CONTROL", "STANDARD_CONTROL"], var.control_finding_generator)
    error_message = "resource_aws_securityhub_account, control_finding_generator must be either 'SECURITY_CONTROL' or 'STANDARD_CONTROL'."
  }
}

variable "auto_enable_controls" {
  description = "Whether to automatically enable new controls when they are added to standards that are enabled. By default, this is set to true, and new controls are enabled automatically."
  type        = bool
  default     = true
}