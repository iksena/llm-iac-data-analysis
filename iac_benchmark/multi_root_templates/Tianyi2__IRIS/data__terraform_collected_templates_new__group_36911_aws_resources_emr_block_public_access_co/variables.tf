variable "block_public_security_group_rules" {
  description = "Enable or disable EMR Block Public Access"
  type        = bool

  validation {
    condition     = can(var.block_public_security_group_rules)
    error_message = "resource_aws_emr_block_public_access_configuration, block_public_security_group_rules must be a boolean value."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_emr_block_public_access_configuration, region must be a valid AWS region format (e.g., us-west-2)."
  }
}

variable "permitted_public_security_group_rule_ranges" {
  description = "Configuration blocks for defining permitted public security group rule port ranges. Only valid if block_public_security_group_rules is set to true"
  type = list(object({
    min_range = number
    max_range = number
  }))
  default = []

  validation {
    condition = alltrue([
      for range in var.permitted_public_security_group_rule_ranges :
      range.min_range >= 1 && range.min_range <= 65535
    ])
    error_message = "resource_aws_emr_block_public_access_configuration, permitted_public_security_group_rule_ranges min_range must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for range in var.permitted_public_security_group_rule_ranges :
      range.max_range >= 1 && range.max_range <= 65535
    ])
    error_message = "resource_aws_emr_block_public_access_configuration, permitted_public_security_group_rule_ranges max_range must be between 1 and 65535."
  }

  validation {
    condition = alltrue([
      for range in var.permitted_public_security_group_rule_ranges :
      range.min_range <= range.max_range
    ])
    error_message = "resource_aws_emr_block_public_access_configuration, permitted_public_security_group_rule_ranges min_range must be less than or equal to max_range."
  }
}