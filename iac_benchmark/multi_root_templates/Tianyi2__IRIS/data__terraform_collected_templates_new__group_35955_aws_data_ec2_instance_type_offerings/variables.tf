variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "filters" {
  description = "One or more configuration blocks containing name-values filters"
  type = list(object({
    name   = string
    values = list(string)
  }))
  default = []

  validation {
    condition = alltrue([
      for filter in var.filters : filter.name != null && filter.name != ""
    ])
    error_message = "data_aws_ec2_instance_type_offerings, filters: filter name cannot be null or empty."
  }

  validation {
    condition = alltrue([
      for filter in var.filters : length(filter.values) > 0
    ])
    error_message = "data_aws_ec2_instance_type_offerings, filters: filter values cannot be empty."
  }
}

variable "location_type" {
  description = "Location type. Defaults to region. Valid values: availability-zone, availability-zone-id, and region."
  type        = string
  default     = "region"

  validation {
    condition = contains([
      "availability-zone",
      "availability-zone-id",
      "region"
    ], var.location_type)
    error_message = "data_aws_ec2_instance_type_offerings, location_type: must be one of availability-zone, availability-zone-id, or region."
  }
}

variable "timeout_read" {
  description = "Configuration option for read timeout"
  type        = string
  default     = "20m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.timeout_read))
    error_message = "data_aws_ec2_instance_type_offerings, timeout_read: must be a valid timeout duration (e.g., 20m, 1h, 30s)."
  }
}