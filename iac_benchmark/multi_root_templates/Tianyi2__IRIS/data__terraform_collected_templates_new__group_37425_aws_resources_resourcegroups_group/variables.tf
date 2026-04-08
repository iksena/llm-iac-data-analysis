variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "The resource group's name. A resource group name can have a maximum of 127 characters, including letters, numbers, hyphens, dots, and underscores. The name cannot start with AWS or aws."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name)) && length(var.name) <= 127 && length(var.name) > 0
    error_message = "resource_aws_resourcegroups_group, name must contain only letters, numbers, hyphens, dots, and underscores, and must be between 1 and 127 characters."
  }

  validation {
    condition     = !can(regex("^[Aa][Ww][Ss]", var.name))
    error_message = "resource_aws_resourcegroups_group, name cannot start with AWS or aws."
  }
}

variable "configuration" {
  description = "A configuration associates the resource group with an AWS service and specifies how the service can interact with the resources in the group."
  type = list(object({
    type = string
    parameters = optional(list(object({
      name   = string
      values = optional(list(string))
    })), [])
  }))
  default = []
}

variable "description" {
  description = "A description of the resource group."
  type        = string
  default     = null
}

variable "resource_query" {
  description = "A resource_query block."
  type = object({
    query = string
    type  = optional(string, "TAG_FILTERS_1_0")
  })

  validation {
    condition     = can(jsondecode(var.resource_query.query))
    error_message = "resource_aws_resourcegroups_group, resource_query.query must be valid JSON."
  }
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}