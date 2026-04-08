variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "map_name" {
  description = "Name of the map resource"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.map_name))
    error_message = "data_aws_location_map, map_name must contain only alphanumeric characters, periods, hyphens, and underscores."
  }
}