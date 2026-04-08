variable "name" {
  description = "The name of the thing"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_iot_thing, name must not be empty."
  }
}

variable "attributes" {
  description = "Map of attributes of the thing"
  type        = map(string)
  default     = null
}

variable "thing_type_name" {
  description = "The thing type name"
  type        = string
  default     = null
}