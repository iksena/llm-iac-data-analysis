variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "location_code" {
  description = "Code for the location to retrieve"
  type        = string

  validation {
    condition     = length(var.location_code) > 0
    error_message = "data_aws_dx_location, location_code must be a non-empty string."
  }
}