variable "calculator_name" {
  description = "The name of the route calculator resource."
  type        = string

  validation {
    condition     = length(var.calculator_name) > 0
    error_message = "resource_aws_location_route_calculator, calculator_name must be a non-empty string."
  }
}

variable "data_source" {
  description = "Specifies the data provider of traffic and road network data."
  type        = string

  validation {
    condition     = length(var.data_source) > 0
    error_message = "resource_aws_location_route_calculator, data_source must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "The optional description for the route calculator resource."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value tags for the route calculator."
  type        = map(string)
  default     = {}
}

variable "create_timeout" {
  description = "Timeout for create operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.create_timeout))
    error_message = "resource_aws_location_route_calculator, create_timeout must be a valid timeout duration (e.g., 30m, 1h, 60s)."
  }
}

variable "update_timeout" {
  description = "Timeout for update operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.update_timeout))
    error_message = "resource_aws_location_route_calculator, update_timeout must be a valid timeout duration (e.g., 30m, 1h, 60s)."
  }
}

variable "delete_timeout" {
  description = "Timeout for delete operation."
  type        = string
  default     = "30m"

  validation {
    condition     = can(regex("^[0-9]+[mhs]$", var.delete_timeout))
    error_message = "resource_aws_location_route_calculator, delete_timeout must be a valid timeout duration (e.g., 30m, 1h, 60s)."
  }
}