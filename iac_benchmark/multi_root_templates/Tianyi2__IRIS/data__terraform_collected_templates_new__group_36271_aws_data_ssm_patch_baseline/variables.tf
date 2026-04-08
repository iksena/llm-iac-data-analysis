variable "owner" {
  type        = string
  description = "Owner of the baseline. Valid values: All, AWS, Self (the current account)."

  validation {
    condition     = contains(["All", "AWS", "Self"], var.owner)
    error_message = "data_aws_ssm_patch_baseline, owner must be one of: All, AWS, Self."
  }
}

variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "default_baseline" {
  type        = bool
  description = "Filters the results against the baselines default_baseline field."
  default     = null
}

variable "name_prefix" {
  type        = string
  description = "Filter results by the baseline name prefix."
  default     = null
}

variable "operating_system" {
  type        = string
  description = "Specified OS for the baseline. Valid values: AMAZON_LINUX, AMAZON_LINUX_2, UBUNTU, REDHAT_ENTERPRISE_LINUX, SUSE, CENTOS, ORACLE_LINUX, DEBIAN, MACOS, RASPBIAN and ROCKY_LINUX."
  default     = null

  validation {
    condition = var.operating_system == null || contains([
      "AMAZON_LINUX",
      "AMAZON_LINUX_2",
      "UBUNTU",
      "REDHAT_ENTERPRISE_LINUX",
      "SUSE",
      "CENTOS",
      "ORACLE_LINUX",
      "DEBIAN",
      "MACOS",
      "RASPBIAN",
      "ROCKY_LINUX"
    ], var.operating_system)
    error_message = "data_aws_ssm_patch_baseline, operating_system must be one of: AMAZON_LINUX, AMAZON_LINUX_2, UBUNTU, REDHAT_ENTERPRISE_LINUX, SUSE, CENTOS, ORACLE_LINUX, DEBIAN, MACOS, RASPBIAN, ROCKY_LINUX."
  }
}