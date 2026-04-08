variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "filter" {
  description = "Configuration block(s) for filtering"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition     = alltrue([for f in var.filter : f.name != null && f.name != ""])
    error_message = "data_aws_imagebuilder_distribution_configurations, filter: name is required and cannot be empty."
  }

  validation {
    condition     = alltrue([for f in var.filter : length(f.values) > 0])
    error_message = "data_aws_imagebuilder_distribution_configurations, filter: values must contain at least one value."
  }

  validation {
    condition     = alltrue([for f in var.filter : alltrue([for v in f.values : v != null && v != ""])])
    error_message = "data_aws_imagebuilder_distribution_configurations, filter: all values must be non-empty strings."
  }
}