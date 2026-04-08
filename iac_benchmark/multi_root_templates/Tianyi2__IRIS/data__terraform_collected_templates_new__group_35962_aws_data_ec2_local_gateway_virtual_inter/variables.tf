variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_ec2_local_gateway_virtual_interface_groups, region must be a valid AWS region format (e.g., us-east-1) or null."
  }
}

variable "filter" {
  description = "One or more configuration blocks containing name-values filters."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_ec2_local_gateway_virtual_interface_groups, filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_local_gateway_virtual_interface_groups, filter values must contain at least one value."
  }
}

variable "tags" {
  description = "Key-value map of resource tags, each pair of which must exactly match a pair on the desired local gateway route table."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : k != null && k != "" && v != null
    ])
    error_message = "data_aws_ec2_local_gateway_virtual_interface_groups, tags keys and values cannot be null or empty."
  }
}

variable "timeouts_read" {
  description = "Timeout for read operations."
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts_read))
    error_message = "data_aws_ec2_local_gateway_virtual_interface_groups, timeouts_read must be a valid timeout format (e.g., 20m, 1h, 30s)."
  }
}