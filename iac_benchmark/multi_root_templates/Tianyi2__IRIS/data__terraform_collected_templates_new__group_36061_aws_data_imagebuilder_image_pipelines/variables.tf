variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_imagebuilder_image_pipelines, region must be a valid AWS region identifier."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering Image Builder Image Pipelines."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_imagebuilder_image_pipelines, filter name is required and cannot be empty."
  }

  validation {
    condition = alltrue([
      for f in var.filter : length(f.values) > 0
    ])
    error_message = "data_aws_imagebuilder_image_pipelines, filter values must contain at least one value."
  }

  validation {
    condition = alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != null && v != ""
      ])
    ])
    error_message = "data_aws_imagebuilder_image_pipelines, filter values cannot be null or empty."
  }
}