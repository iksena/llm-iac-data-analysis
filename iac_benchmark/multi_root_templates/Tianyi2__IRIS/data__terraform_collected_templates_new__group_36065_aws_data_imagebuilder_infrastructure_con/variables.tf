variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_imagebuilder_infrastructure_configurations, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "filter" {
  description = "Configuration block(s) for filtering."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = null

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.name != null && f.name != ""
    ])
    error_message = "data_aws_imagebuilder_infrastructure_configurations, filter name is required and cannot be empty."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : f.values != null && length(f.values) > 0
    ])
    error_message = "data_aws_imagebuilder_infrastructure_configurations, filter values is required and must contain at least one value."
  }

  validation {
    condition = var.filter == null || alltrue([
      for f in var.filter : alltrue([
        for v in f.values : v != null && v != ""
      ])
    ])
    error_message = "data_aws_imagebuilder_infrastructure_configurations, filter values cannot contain null or empty strings."
  }
}