variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "baseline_id" {
  description = "ID of the patch baseline. Can be an ID or an ARN. When specifying an AWS-provided patch baseline, must be the ARN."
  type        = string

  validation {
    condition     = length(var.baseline_id) > 0
    error_message = "resource_aws_ssm_default_patch_baseline, baseline_id must not be empty."
  }
}

variable "operating_system" {
  description = "The operating system the patch baseline applies to."
  type        = string

  validation {
    condition = contains([
      "AMAZON_LINUX",
      "AMAZON_LINUX_2",
      "AMAZON_LINUX_2022",
      "CENTOS",
      "DEBIAN",
      "MACOS",
      "ORACLE_LINUX",
      "RASPBIAN",
      "REDHAT_ENTERPRISE_LINUX",
      "ROCKY_LINUX",
      "SUSE",
      "UBUNTU",
      "WINDOWS"
    ], var.operating_system)
    error_message = "resource_aws_ssm_default_patch_baseline, operating_system must be one of: AMAZON_LINUX, AMAZON_LINUX_2, AMAZON_LINUX_2022, CENTOS, DEBIAN, MACOS, ORACLE_LINUX, RASPBIAN, REDHAT_ENTERPRISE_LINUX, ROCKY_LINUX, SUSE, UBUNTU, WINDOWS."
  }
}