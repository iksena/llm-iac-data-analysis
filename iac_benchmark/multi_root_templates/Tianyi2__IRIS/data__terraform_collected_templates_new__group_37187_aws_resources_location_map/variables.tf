variable "map_name" {
  description = "The name for the map resource."
  type        = string

  validation {
    condition     = length(var.map_name) > 0
    error_message = "resource_aws_location_map, map_name must not be empty."
  }
}

variable "configuration" {
  description = "Configuration block with the map style selected from an available data provider."
  type = object({
    style = string
  })

  validation {
    condition     = length(var.configuration.style) > 0
    error_message = "resource_aws_location_map, configuration.style must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "An optional description for the map resource."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value tags for the map. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}