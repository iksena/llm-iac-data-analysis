variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "index_name" {
  description = "Name of the place index resource."
  type        = string

  validation {
    condition     = length(var.index_name) > 0
    error_message = "data_aws_location_place_index, index_name must not be empty."
  }
}