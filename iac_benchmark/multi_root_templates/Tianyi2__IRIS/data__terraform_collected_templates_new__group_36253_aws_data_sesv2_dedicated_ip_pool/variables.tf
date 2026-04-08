variable "pool_name" {
  description = "Name of the dedicated IP pool."
  type        = string

  validation {
    condition     = length(var.pool_name) > 0
    error_message = "data_aws_sesv2_dedicated_ip_pool, pool_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}