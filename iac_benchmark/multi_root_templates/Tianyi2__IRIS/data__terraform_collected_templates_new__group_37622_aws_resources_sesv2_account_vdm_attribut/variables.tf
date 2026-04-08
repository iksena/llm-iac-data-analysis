variable "vdm_enabled" {
  description = "Specifies the status of your VDM configuration"
  type        = string

  validation {
    condition     = contains(["ENABLED", "DISABLED"], var.vdm_enabled)
    error_message = "resource_aws_sesv2_account_vdm_attributes, vdm_enabled must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "dashboard_attributes" {
  description = "Specifies additional settings for your VDM configuration as applicable to the Dashboard"
  type = object({
    engagement_metrics = optional(string)
  })
  default = null

  validation {
    condition = var.dashboard_attributes == null || (
      var.dashboard_attributes.engagement_metrics == null ||
      contains(["ENABLED", "DISABLED"], var.dashboard_attributes.engagement_metrics)
    )
    error_message = "resource_aws_sesv2_account_vdm_attributes, dashboard_attributes.engagement_metrics must be either 'ENABLED' or 'DISABLED'."
  }
}

variable "guardian_attributes" {
  description = "Specifies additional settings for your VDM configuration as applicable to the Guardian"
  type = object({
    optimized_shared_delivery = optional(string)
  })
  default = null

  validation {
    condition = var.guardian_attributes == null || (
      var.guardian_attributes.optimized_shared_delivery == null ||
      contains(["ENABLED", "DISABLED"], var.guardian_attributes.optimized_shared_delivery)
    )
    error_message = "resource_aws_sesv2_account_vdm_attributes, guardian_attributes.optimized_shared_delivery must be either 'ENABLED' or 'DISABLED'."
  }
}