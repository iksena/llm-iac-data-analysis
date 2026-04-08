variable "name" {
  description = "DB parameter group name"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_db_parameter_group, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}