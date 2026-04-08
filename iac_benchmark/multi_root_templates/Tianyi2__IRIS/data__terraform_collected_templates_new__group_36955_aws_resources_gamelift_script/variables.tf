variable "name" {
  description = "Name of the script"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_gamelift_script, name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "storage_location" {
  description = "Information indicating where your game script files are stored"
  type = object({
    bucket         = string
    key            = string
    role_arn       = string
    object_version = optional(string)
  })
  default = null

  validation {
    condition = var.storage_location == null || (
      length(var.storage_location.bucket) > 0 &&
      length(var.storage_location.key) > 0 &&
      length(var.storage_location.role_arn) > 0
    )
    error_message = "resource_aws_gamelift_script, storage_location bucket, key, and role_arn are required when storage_location is specified."
  }

  validation {
    condition     = var.storage_location == null || can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.storage_location.role_arn))
    error_message = "resource_aws_gamelift_script, storage_location role_arn must be a valid IAM role ARN."
  }
}

variable "script_version" {
  description = "Version that is associated with this script"
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags"
  type        = map(string)
  default     = {}
}

variable "zip_file" {
  description = "A data object containing your Realtime scripts and dependencies as a zip file. Maximum size of a zip file is 5 MB."
  type        = string
  default     = null

  validation {
    condition     = var.zip_file == null || length(var.zip_file) > 0
    error_message = "resource_aws_gamelift_script, zip_file must not be empty when specified."
  }
}