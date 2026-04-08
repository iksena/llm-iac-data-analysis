variable "bucket_name" {
  description = "Name of the bucket to grant access to"
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.bucket_name)) && length(var.bucket_name) >= 3 && length(var.bucket_name) <= 63
    error_message = "resource_aws_lightsail_bucket_resource_access, bucket_name must be between 3 and 63 characters long and contain only lowercase letters, numbers, periods, and hyphens."
  }
}

variable "resource_name" {
  description = "Name of the resource to grant bucket access"
  type        = string

  validation {
    condition     = length(var.resource_name) > 0
    error_message = "resource_aws_lightsail_bucket_resource_access, resource_name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_lightsail_bucket_resource_access, region must be a valid AWS region format."
  }
}