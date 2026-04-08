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
    error_message = "data_aws_imagebuilder_image_recipes, owner must be one of: Self, Shared, Amazon, ThirdParty."
  }
}

variable "filters" {
  description = "Configuration block(s) for filtering Image Builder Image Recipes."
  type = list(object({
    name   = string
    values = set(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : filter.name != null && filter.name != ""
    ])
    error_message = "data_aws_imagebuilder_image_recipes, filters name must be a non-empty string."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_imagebuilder_image_recipes, filters values must contain at least one value."
  }
}