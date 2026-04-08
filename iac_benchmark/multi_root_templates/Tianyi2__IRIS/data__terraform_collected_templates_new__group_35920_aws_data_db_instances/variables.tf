variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filters" {
  description = "Configuration blocks used to filter instances with AWS supported attributes."
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : filter.name != null && filter.name != ""
    ])
    error_message = "data_aws_db_instances, filters: filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_db_instances, filters: filter values must contain at least one value."
  }
}

variable "tags" {
  description = "Map of tags, each pair of which must exactly match a pair on the desired instances."
  type        = map(string)
  default     = {}
}