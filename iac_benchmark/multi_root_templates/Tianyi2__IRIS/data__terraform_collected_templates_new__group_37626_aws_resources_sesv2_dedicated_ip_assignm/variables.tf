variable "ip" {
  description = "Dedicated IP address"
  type        = string

  validation {
    condition     = can(regex("^((25[0-5]|(2[0-4]|1\\d|[1-9]|)\\d)\\.?\\b){4}$", var.ip))
    error_message = "resource_aws_sesv2_dedicated_ip_assignment, ip must be a valid IPv4 address."
  }
}

variable "destination_pool_name" {
  description = "Dedicated IP pool name"
  type        = string

  validation {
    condition     = length(var.destination_pool_name) > 0
    error_message = "resource_aws_sesv2_dedicated_ip_assignment, destination_pool_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}