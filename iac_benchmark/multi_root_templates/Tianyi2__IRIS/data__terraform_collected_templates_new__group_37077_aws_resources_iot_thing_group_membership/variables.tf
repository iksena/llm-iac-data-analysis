variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "thing_name" {
  description = "The name of the thing to add to a group."
  type        = string

  validation {
    condition     = length(var.thing_name) > 0
    error_message = "resource_aws_iot_thing_group_membership, thing_name must not be empty."
  }
}

variable "thing_group_name" {
  description = "The name of the group to which you are adding a thing."
  type        = string

  validation {
    condition     = length(var.thing_group_name) > 0
    error_message = "resource_aws_iot_thing_group_membership, thing_group_name must not be empty."
  }
}

variable "override_dynamic_group" {
  description = "Override dynamic thing groups with static thing groups when 10-group limit is reached. If a thing belongs to 10 thing groups, and one or more of those groups are dynamic thing groups, adding a thing to a static group removes the thing from the last dynamic group."
  type        = bool
  default     = null
}