variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "asset_id" {
  description = "The ID of the Outpost hardware asset on which to allocate the Dedicated Hosts. This parameter is supported only if you specify OutpostArn. If you are allocating the Dedicated Hosts in a Region, omit this parameter."
  type        = string
  default     = null
}

variable "auto_placement" {
  description = "Indicates whether the host accepts any untargeted instance launches that match its instance type configuration, or if it only accepts Host tenancy instance launches that specify its unique host ID."
  type        = string
  default     = "on"

  validation {
    condition     = contains(["on", "off"], var.auto_placement)
    error_message = "resource_aws_ec2_host, auto_placement must be either 'on' or 'off'."
  }
}

variable "availability_zone" {
  description = "The Availability Zone in which to allocate the Dedicated Host."
  type        = string

  validation {
    condition     = var.availability_zone != null && var.availability_zone != ""
    error_message = "resource_aws_ec2_host, availability_zone is required and cannot be empty."
  }
}

variable "host_recovery" {
  description = "Indicates whether to enable or disable host recovery for the Dedicated Host."
  type        = string
  default     = "off"

  validation {
    condition     = contains(["on", "off"], var.host_recovery)
    error_message = "resource_aws_ec2_host, host_recovery must be either 'on' or 'off'."
  }
}

variable "instance_family" {
  description = "Specifies the instance family to be supported by the Dedicated Hosts. If you specify an instance family, the Dedicated Hosts support multiple instance types within that instance family. Exactly one of instance_family or instance_type must be specified."
  type        = string
  default     = null
}

variable "instance_type" {
  description = "Specifies the instance type to be supported by the Dedicated Hosts. If you specify an instance type, the Dedicated Hosts support instances of the specified instance type only. Exactly one of instance_family or instance_type must be specified."
  type        = string
  default     = null
}

variable "outpost_arn" {
  description = "The Amazon Resource Name (ARN) of the AWS Outpost on which to allocate the Dedicated Host."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to this resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

