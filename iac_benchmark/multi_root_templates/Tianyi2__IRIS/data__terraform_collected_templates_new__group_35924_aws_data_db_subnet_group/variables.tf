variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "name" {
  type        = string
  description = "Name of the RDS database subnet group."

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_db_subnet_group, name must not be empty."
  }
}