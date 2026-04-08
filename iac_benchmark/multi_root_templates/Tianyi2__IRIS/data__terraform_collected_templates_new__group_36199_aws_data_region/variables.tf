variable "region" {
  description = "Full name of the region to select (e.g. us-east-1), and the region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_region, region must be a valid AWS region name (e.g., us-east-1)."
  }
}

variable "endpoint" {
  description = "EC2 endpoint of the region to select"
  type        = string
  default     = null

  validation {
    condition     = var.endpoint == null || can(regex("^https://", var.endpoint))
    error_message = "data_aws_region, endpoint must be a valid HTTPS URL."
  }
}

variable "name" {
  description = "Full name of the region to select. Use region instead (deprecated)"
  type        = string
  default     = null

  validation {
    condition     = var.name == null || can(regex("^[a-z0-9-]+$", var.name))
    error_message = "data_aws_region, name must be a valid AWS region name (e.g., us-east-1). This variable is deprecated, use region instead."
  }
}