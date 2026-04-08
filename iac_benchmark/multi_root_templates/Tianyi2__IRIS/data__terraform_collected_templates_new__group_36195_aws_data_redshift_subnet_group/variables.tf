variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "name" {
  type        = string
  description = "Name of the cluster subnet group for which information is requested."

  validation {
    condition     = var.name != null && var.name != ""
    error_message = "data_aws_redshift_subnet_group, name cannot be null or empty."
  }
}