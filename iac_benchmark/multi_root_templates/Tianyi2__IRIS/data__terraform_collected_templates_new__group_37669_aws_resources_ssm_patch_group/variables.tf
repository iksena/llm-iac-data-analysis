variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "baseline_id" {
  description = "The ID of the patch baseline to register the patch group with."
  type        = string

  validation {
    condition     = can(regex("^pb-[0-9a-f]{17}$", var.baseline_id))
    error_message = "resource_aws_ssm_patch_group, baseline_id must be a valid patch baseline ID format (pb- followed by 17 alphanumeric characters)."
  }
}

variable "patch_group" {
  description = "The name of the patch group that should be registered with the patch baseline."
  type        = string

  validation {
    condition     = length(var.patch_group) > 0 && length(var.patch_group) <= 256
    error_message = "resource_aws_ssm_patch_group, patch_group must be between 1 and 256 characters in length."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.patch_group))
    error_message = "resource_aws_ssm_patch_group, patch_group can only contain alphanumeric characters, periods, hyphens, and underscores."
  }
}