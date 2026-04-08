variable "resource_type" {
  description = "Resource type to be retained by the retention rule. Valid values are EBS_SNAPSHOT and EC2_IMAGE."
  type        = string

  validation {
    condition     = contains(["EBS_SNAPSHOT", "EC2_IMAGE"], var.resource_type)
    error_message = "resource_aws_rbin_rule, resource_type must be either 'EBS_SNAPSHOT' or 'EC2_IMAGE'."
  }
}

variable "retention_period" {
  description = "Information about the retention period for which the retention rule is to retain resources."
  type = object({
    retention_period_value = number
    retention_period_unit  = string
  })

  validation {
    condition     = var.retention_period.retention_period_unit == "DAYS"
    error_message = "resource_aws_rbin_rule, retention_period_unit must be 'DAYS'."
  }

  validation {
    condition     = var.retention_period.retention_period_value > 0
    error_message = "resource_aws_rbin_rule, retention_period_value must be greater than 0."
  }
}

variable "description" {
  description = "Retention rule description."
  type        = string
  default     = null
}

variable "resource_tags" {
  description = "Resource tags to use to identify resources that are to be retained by a tag-level retention rule."
  type = object({
    resource_tag_key   = string
    resource_tag_value = optional(string)
  })
  default = null
}

variable "exclude_resource_tags" {
  description = "Exclusion tags to use to identify resources that are to be excluded, or ignored, by a Region-level retention rule."
  type = object({
    resource_tag_key   = string
    resource_tag_value = optional(string)
  })
  default = null
}

variable "lock_configuration" {
  description = "Information about the retention rule lock configuration."
  type = object({
    unlock_delay = object({
      unlock_delay_unit  = string
      unlock_delay_value = number
    })
  })
  default = null

  validation {
    condition = var.lock_configuration == null ? true : (
      var.lock_configuration.unlock_delay.unlock_delay_unit == "DAYS" &&
      var.lock_configuration.unlock_delay.unlock_delay_value > 0
    )
    error_message = "resource_aws_rbin_rule, unlock_delay_unit must be 'DAYS' and unlock_delay_value must be greater than 0."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}