variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the connection to retrieve."
  type        = string

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_dx_connection, name must be a non-empty string."
  }
}