variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "account_id" {
  description = "The AWS account ID for the owner of the buckets for which you want to create a Multi-Region Access Point. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null
}

variable "details" {
  description = "A configuration block containing details about the Multi-Region Access Point."
  type = object({
    name = string
    public_access_block = optional(object({
      block_public_acls       = optional(bool, true)
      block_public_policy     = optional(bool, true)
      ignore_public_acls      = optional(bool, true)
      restrict_public_buckets = optional(bool, true)
    }))
    regions = list(object({
      bucket            = string
      bucket_account_id = optional(string)
    }))
  })

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", var.details.name))
    error_message = "resource_aws_s3control_multi_region_access_point, name must be a valid Multi-Region Access Point name containing only lowercase letters, numbers, and hyphens, and must start and end with a letter or number."
  }

  validation {
    condition     = length(var.details.name) >= 3 && length(var.details.name) <= 50
    error_message = "resource_aws_s3control_multi_region_access_point, name must be between 3 and 50 characters long."
  }

  validation {
    condition     = length(var.details.regions) >= 1
    error_message = "resource_aws_s3control_multi_region_access_point, regions must contain at least one region configuration."
  }

  validation {
    condition = alltrue([
      for region in var.details.regions : can(regex("^[a-z0-9][a-z0-9\\-]*[a-z0-9]$", region.bucket))
    ])
    error_message = "resource_aws_s3control_multi_region_access_point, bucket names in regions must be valid S3 bucket names."
  }

  validation {
    condition = var.details.public_access_block == null ? true : alltrue([
      for key, value in var.details.public_access_block : contains(["block_public_acls", "block_public_policy", "ignore_public_acls", "restrict_public_buckets"], key)
    ])
    error_message = "resource_aws_s3control_multi_region_access_point, public_access_block can only contain block_public_acls, block_public_policy, ignore_public_acls, and restrict_public_buckets."
  }
}

variable "timeouts" {
  description = "Configuration options for operation timeouts."
  type = object({
    create = optional(string, "60m")
    delete = optional(string, "15m")
  })
  default = {
    create = "60m"
    delete = "15m"
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_s3control_multi_region_access_point, timeouts.create must be a valid duration string (e.g., 60m, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_s3control_multi_region_access_point, timeouts.delete must be a valid duration string (e.g., 15m, 1h)."
  }
}