variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_vpc_security_group_rule, region must be a valid AWS region format."
  }
}

variable "security_group_rule_id" {
  description = "ID of the security group rule to select."
  type        = string
  default     = null

  validation {
    condition     = var.security_group_rule_id == null || can(regex("^sgr-[0-9a-f]{8,17}$", var.security_group_rule_id))
    error_message = "data_aws_vpc_security_group_rule, security_group_rule_id must be a valid security group rule ID format (sgr-xxxxxxxx)."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering. Each filter block supports name and values."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc_security_group_rule, filter name must not be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_vpc_security_group_rule, filter values must contain at least one value."
  }
}