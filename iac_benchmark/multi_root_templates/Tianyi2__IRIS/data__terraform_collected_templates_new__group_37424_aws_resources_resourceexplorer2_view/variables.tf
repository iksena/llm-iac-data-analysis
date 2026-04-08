variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "default_view" {
  description = "Specifies whether the view is the default view for the AWS Region."
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the view. The name must be no more than 64 characters long, and can include letters, digits, and the dash (-) character. The name must be unique within its AWS Region."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,64}$", var.name))
    error_message = "resource_aws_resourceexplorer2_view, name must be no more than 64 characters long and can only include letters, digits, and the dash (-) character."
  }
}

variable "scope" {
  description = "The root ARN of the account, an organizational unit (OU), or an organization ARN. If left empty, the default is account."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags."
  type        = map(string)
  default     = {}
}

variable "filters" {
  description = "Specifies which resources are included in the results of queries made using this view."
  type = object({
    filter_string = string
  })
  default = null

  validation {
    condition     = var.filters == null || can(var.filters.filter_string)
    error_message = "resource_aws_resourceexplorer2_view, filters.filter_string is required when filters block is specified."
  }
}

variable "included_properties" {
  description = "Optional fields to be included in search results from this view."
  type = list(object({
    name = string
  }))
  default = []

  validation {
    condition = alltrue([
      for prop in var.included_properties : contains(["tags"], prop.name)
    ])
    error_message = "resource_aws_resourceexplorer2_view, included_properties.name must be 'tags'."
  }
}