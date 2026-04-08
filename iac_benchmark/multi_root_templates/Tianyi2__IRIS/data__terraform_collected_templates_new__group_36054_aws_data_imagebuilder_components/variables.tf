variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "owner" {
  description = "Owner of the image recipes. Valid values are Self, Shared, Amazon and ThirdParty. Defaults to Self."
  type        = string
  default     = "Self"

  validation {
    condition     = contains(["Self", "Shared", "Amazon", "ThirdParty"], var.owner)
    error_message = "data_aws_imagebuilder_components, owner must be one of: Self, Shared, Amazon, ThirdParty."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && length(f.name) > 0
    ])
    error_message = "data_aws_imagebuilder_components, filter name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_imagebuilder_components, filter values is required and cannot be empty."
  }
}