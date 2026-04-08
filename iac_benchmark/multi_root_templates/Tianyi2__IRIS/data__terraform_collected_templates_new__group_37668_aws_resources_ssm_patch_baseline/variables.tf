variable "name" {
  type        = string
  description = "Name of the patch baseline."

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_ssm_patch_baseline, name cannot be empty."
  }
}

variable "description" {
  type        = string
  description = "Description of the patch baseline."
  default     = null
}

variable "operating_system" {
  type        = string
  description = "Operating system the patch baseline applies to."
  default     = "WINDOWS"

  validation {
    condition = contains([
      "ALMA_LINUX", "AMAZON_LINUX", "AMAZON_LINUX_2", "AMAZON_LINUX_2022",
      "AMAZON_LINUX_2023", "CENTOS", "DEBIAN", "MACOS", "ORACLE_LINUX",
      "RASPBIAN", "REDHAT_ENTERPRISE_LINUX", "ROCKY_LINUX", "SUSE", "UBUNTU", "WINDOWS"
    ], var.operating_system)
    error_message = "resource_aws_ssm_patch_baseline, operating_system must be one of: ALMA_LINUX, AMAZON_LINUX, AMAZON_LINUX_2, AMAZON_LINUX_2022, AMAZON_LINUX_2023, CENTOS, DEBIAN, MACOS, ORACLE_LINUX, RASPBIAN, REDHAT_ENTERPRISE_LINUX, ROCKY_LINUX, SUSE, UBUNTU, WINDOWS."
  }
}

variable "approved_patches" {
  type        = list(string)
  description = "List of explicitly approved patches for the baseline."
  default     = null
}

variable "approved_patches_compliance_level" {
  type        = string
  description = "Compliance level for approved patches."
  default     = "UNSPECIFIED"

  validation {
    condition     = contains(["CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL", "UNSPECIFIED"], var.approved_patches_compliance_level)
    error_message = "resource_aws_ssm_patch_baseline, approved_patches_compliance_level must be one of: CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, UNSPECIFIED."
  }
}

variable "approved_patches_enable_non_security" {
  type        = bool
  description = "Whether the list of approved patches includes non-security updates that should be applied to the instances."
  default     = null
}

variable "available_security_updates_compliance_status" {
  type        = string
  description = "Indicates the compliance status of managed nodes for which security-related patches are available but were not approved."
  default     = null

  validation {
    condition     = var.available_security_updates_compliance_status == null || contains(["COMPLIANT", "NON_COMPLIANT"], var.available_security_updates_compliance_status)
    error_message = "resource_aws_ssm_patch_baseline, available_security_updates_compliance_status must be one of: COMPLIANT, NON_COMPLIANT."
  }
}

variable "rejected_patches" {
  type        = list(string)
  description = "List of rejected patches."
  default     = null
}

variable "rejected_patches_action" {
  type        = string
  description = "Action for Patch Manager to take on patches included in the rejected_patches list."
  default     = null

  validation {
    condition     = var.rejected_patches_action == null || contains(["ALLOW_AS_DEPENDENCY", "BLOCK"], var.rejected_patches_action)
    error_message = "resource_aws_ssm_patch_baseline, rejected_patches_action must be one of: ALLOW_AS_DEPENDENCY, BLOCK."
  }
}

variable "tags" {
  type        = map(string)
  description = "Map of tags to assign to the resource."
  default     = {}
}

variable "approval_rules" {
  type = list(object({
    approve_after_days  = optional(number)
    approve_until_date  = optional(string)
    compliance_level    = optional(string, "UNSPECIFIED")
    enable_non_security = optional(bool)
    patch_filters = list(object({
      key    = string
      values = list(string)
    }))
  }))
  description = "Set of rules used to include patches in the baseline."
  default     = []

  validation {
    condition     = length(var.approval_rules) <= 10
    error_message = "resource_aws_ssm_patch_baseline, approval_rules cannot exceed 10 rules."
  }

  validation {
    condition = alltrue([
      for rule in var.approval_rules : rule.compliance_level == null || contains(["CRITICAL", "HIGH", "MEDIUM", "LOW", "INFORMATIONAL", "UNSPECIFIED"], rule.compliance_level)
    ])
    error_message = "resource_aws_ssm_patch_baseline, approval_rules compliance_level must be one of: CRITICAL, HIGH, MEDIUM, LOW, INFORMATIONAL, UNSPECIFIED."
  }

  validation {
    condition = alltrue([
      for rule in var.approval_rules : rule.approve_after_days == null || (rule.approve_after_days >= 0 && rule.approve_after_days <= 360)
    ])
    error_message = "resource_aws_ssm_patch_baseline, approval_rules approve_after_days must be between 0 and 360."
  }

  validation {
    condition = alltrue([
      for rule in var.approval_rules : length(rule.patch_filters) <= 5
    ])
    error_message = "resource_aws_ssm_patch_baseline, approval_rules patch_filters cannot exceed 5 filters per rule."
  }
}

variable "global_filters" {
  type = list(object({
    key    = string
    values = list(string)
  }))
  description = "Set of global filters used to exclude patches from the baseline."
  default     = []

  validation {
    condition     = length(var.global_filters) <= 4
    error_message = "resource_aws_ssm_patch_baseline, global_filters cannot exceed 4 filters."
  }

  validation {
    condition = alltrue([
      for filter in var.global_filters : contains(["PRODUCT", "CLASSIFICATION", "MSRC_SEVERITY", "PATCH_ID"], filter.key)
    ])
    error_message = "resource_aws_ssm_patch_baseline, global_filters key must be one of: PRODUCT, CLASSIFICATION, MSRC_SEVERITY, PATCH_ID."
  }
}

variable "sources" {
  type = list(object({
    configuration = string
    name          = string
    products      = list(string)
  }))
  description = "Configuration block with alternate sources for patches."
  default     = []

  validation {
    condition = alltrue([
      for source in var.sources : length(source.name) > 0
    ])
    error_message = "resource_aws_ssm_patch_baseline, sources name cannot be empty."
  }

  validation {
    condition = alltrue([
      for source in var.sources : length(source.configuration) > 0
    ])
    error_message = "resource_aws_ssm_patch_baseline, sources configuration cannot be empty."
  }

  validation {
    condition = alltrue([
      for source in var.sources : length(source.products) > 0
    ])
    error_message = "resource_aws_ssm_patch_baseline, sources products cannot be empty."
  }
}