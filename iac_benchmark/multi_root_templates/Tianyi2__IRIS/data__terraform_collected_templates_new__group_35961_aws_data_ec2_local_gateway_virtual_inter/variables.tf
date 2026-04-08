variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "data_aws_ec2_local_gateway_virtual_interface_group, region must be a valid AWS region format (e.g., us-west-2)."
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
    error_message = "data_aws_ec2_local_gateway_virtual_interface_group, filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_ec2_local_gateway_virtual_interface_group, filter values must contain at least one value."
  }
}

variable "id" {
  description = "Identifier of EC2 Local Gateway Virtual Interface Group."
  type        = string
  default     = null

  validation {
    condition     = var.id == null || can(regex("^lgw-vif-grp-[a-z0-9]+$", var.id))
    error_message = "data_aws_ec2_local_gateway_virtual_interface_group, id must be a valid local gateway virtual interface group ID format."
  }
}

variable "local_gateway_id" {
  description = "Identifier of EC2 Local Gateway."
  type        = string
  default     = null

  validation {
    condition     = var.local_gateway_id == null || can(regex("^lgw-[a-z0-9]+$", var.local_gateway_id))
    error_message = "data_aws_ec2_local_gateway_virtual_interface_group, local_gateway_id must be a valid local gateway ID format."
  }
}

variable "tags" {
  description = "Key-value map of resource tags, each pair of which must exactly match a pair on the desired local gateway virtual interface group."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : k != null && k != "" && v != null
    ])
    error_message = "data_aws_ec2_local_gateway_virtual_interface_group, tags keys and values cannot be null or empty."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    read = optional(string, "20m")
  })
  default = {
    read = "20m"
  }

  validation {
    condition     = can(regex("^[0-9]+[ms]$", var.timeouts.read))
    error_message = "data_aws_ec2_local_gateway_virtual_interface_group, timeouts read must be a valid duration (e.g., 20m, 300s)."
  }
}