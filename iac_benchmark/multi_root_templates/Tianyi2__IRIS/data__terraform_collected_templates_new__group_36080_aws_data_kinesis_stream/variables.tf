variable "name" {
  description = "Name of the Kinesis Stream"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_kinesis_stream, name must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || length(var.region) > 0
    error_message = "data_kinesis_stream, region must be a non-empty string when specified."
  }
}