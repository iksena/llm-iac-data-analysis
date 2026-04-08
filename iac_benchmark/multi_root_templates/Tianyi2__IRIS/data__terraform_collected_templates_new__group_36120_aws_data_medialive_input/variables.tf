variable "id" {
  description = "The ID of the Input"
  type        = string

  validation {
    condition     = length(var.id) > 0
    error_message = "data_aws_medialive_input, id must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}