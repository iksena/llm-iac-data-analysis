variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filter" {
  description = "Custom filter blocks to apply to the security group rules query."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_vpc_security_group_rules, filter: name is required and cannot be empty."
  }

  validation {
    condition = var.filter == null ? true : alltrue([
      for f in var.filter : f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_vpc_security_group_rules, filter: values is required and cannot be empty."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired security group rule."
  type        = map(string)
  default     = null
}