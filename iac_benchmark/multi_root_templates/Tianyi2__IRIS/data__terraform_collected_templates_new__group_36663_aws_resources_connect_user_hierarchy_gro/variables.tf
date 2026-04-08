variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance."
  type        = string

  validation {
    condition     = can(regex("^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$", var.instance_id))
    error_message = "resource_aws_connect_user_hierarchy_group, instance_id must be a valid UUID format."
  }
}

variable "name" {
  description = "The name of the user hierarchy group. Must not be more than 100 characters."
  type        = string

  validation {
    condition     = length(var.name) <= 100 && length(var.name) > 0
    error_message = "resource_aws_connect_user_hierarchy_group, name must be between 1 and 100 characters."
  }
}

variable "parent_group_id" {
  description = "The identifier for the parent hierarchy group. The user hierarchy is created at level one if the parent group ID is null."
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to apply to the hierarchy group. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}