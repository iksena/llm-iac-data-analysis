variable "account_id" {
  description = "The AWS account ID that owns the specified access point"
  type        = string

  validation {
    condition     = can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3control_directory_bucket_access_point_scope, account_id must be a 12-digit AWS account ID."
  }
}

variable "name" {
  description = "The name of the access point that you want to apply the scope to"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_s3control_directory_bucket_access_point_scope, name cannot be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "scope" {
  description = "Scope is used to restrict access to specific prefixes, API operations, or a combination of both"
  type = object({
    permissions = optional(list(string), [])
    prefixes    = optional(list(string), [])
  })
  default = null

  validation {
    condition = var.scope == null ? true : (
      sum([for prefix in var.scope.prefixes : length(prefix)]) < 256
    )
    error_message = "resource_aws_s3control_directory_bucket_access_point_scope, scope.prefixes total length of characters of all prefixes must be less than 256 bytes."
  }
}