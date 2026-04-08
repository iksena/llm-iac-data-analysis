variable "calculator_name" {
  description = "Name of the route calculator resource"
  type        = string

  validation {
    condition     = length(var.calculator_name) > 0
    error_message = "data_aws_location_route_calculator, calculator_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}