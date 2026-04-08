variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The name of the Thing Group."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_iot_thing_group, name must be a non-empty string."
  }
}

variable "parent_group_name" {
  description = "The name of the parent Thing Group."
  type        = string
  default     = null
}

variable "properties" {
  description = "The Thing Group properties."
  type = object({
    description = optional(string)
    attribute_payload = optional(object({
      attributes = optional(map(string))
    }))
  })
  default = null
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}