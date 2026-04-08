variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "data_aws_s3control_multi_region_access_point, region must be a valid AWS region identifier or null."
  }
}

variable "account_id" {
  description = "The AWS account ID of the S3 Multi-Region Access Point. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "data_aws_s3control_multi_region_access_point, account_id must be a valid 12-digit AWS account ID or null."
  }
}

variable "name" {
  description = "The name of the Multi-Region Access Point."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.name)) && length(var.name) >= 3 && length(var.name) <= 50
    error_message = "data_aws_s3control_multi_region_access_point, name must be between 3 and 50 characters, start and end with lowercase alphanumeric characters, and contain only lowercase alphanumeric characters and hyphens."
  }
}