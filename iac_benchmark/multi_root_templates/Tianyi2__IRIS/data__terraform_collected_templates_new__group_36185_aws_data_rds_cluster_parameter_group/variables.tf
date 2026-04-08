variable "name" {
  description = "DB cluster parameter group name."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_rds_cluster_parameter_group, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}