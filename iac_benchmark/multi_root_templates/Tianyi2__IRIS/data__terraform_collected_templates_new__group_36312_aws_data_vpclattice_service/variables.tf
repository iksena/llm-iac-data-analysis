variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "data_aws_vpclattice_service, region must be a valid AWS region format (e.g., us-east-1)."
  }
}

variable "name" {
  description = "Service name."
  type        = string
  default     = null

  validation {
    condition     = var.name == null || length(var.name) > 0
    error_message = "data_aws_vpclattice_service, name must not be empty if provided."
  }
}

variable "service_identifier" {
  description = "ID or Amazon Resource Name (ARN) of the service."
  type        = string
  default     = null

  validation {
    condition     = var.service_identifier == null || length(var.service_identifier) > 0
    error_message = "data_aws_vpclattice_service, service_identifier must not be empty if provided."
  }
}