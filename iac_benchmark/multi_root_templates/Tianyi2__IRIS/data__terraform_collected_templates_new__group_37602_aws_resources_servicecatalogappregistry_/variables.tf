variable "name" {
  description = "Name of the Attribute Group."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_servicecatalogappregistry_attribute_group, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "attributes" {
  description = "A JSON string of nested key-value pairs that represents the attributes of the group."
  type        = string

  validation {
    condition     = can(jsondecode(var.attributes))
    error_message = "resource_aws_servicecatalogappregistry_attribute_group, attributes must be a valid JSON string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "Description of the Attribute Group."
  type        = string
  default     = null
}

variable "tags" {
  description = "A map of tags assigned to the Attribute Group."
  type        = map(string)
  default     = {}
}