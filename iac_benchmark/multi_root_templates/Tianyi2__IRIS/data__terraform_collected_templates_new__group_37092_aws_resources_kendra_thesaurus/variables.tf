variable "index_id" {
  description = "The identifier of the index for a thesaurus."
  type        = string

  validation {
    condition     = length(var.index_id) > 0
    error_message = "resource_aws_kendra_thesaurus, index_id must be a non-empty string."
  }
}

variable "name" {
  description = "The name for the thesaurus."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_kendra_thesaurus, name must be a non-empty string."
  }
}

variable "role_arn" {
  description = "The IAM (Identity and Access Management) role used to access the thesaurus file in S3."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.*", var.role_arn))
    error_message = "resource_aws_kendra_thesaurus, role_arn must be a valid IAM role ARN."
  }
}

variable "source_s3_path" {
  description = "The S3 path where your thesaurus file sits in S3."
  type = object({
    bucket = string
    key    = string
  })

  validation {
    condition     = length(var.source_s3_path.bucket) > 0
    error_message = "resource_aws_kendra_thesaurus, source_s3_path.bucket must be a non-empty string."
  }

  validation {
    condition     = length(var.source_s3_path.key) > 0
    error_message = "resource_aws_kendra_thesaurus, source_s3_path.key must be a non-empty string."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "description" {
  description = "The description for a thesaurus."
  type        = string
  default     = null
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource operation timeouts."
  type = object({
    create = optional(string, "30m")
    update = optional(string, "30m")
    delete = optional(string, "30m")
  })
  default = {
    create = "30m"
    update = "30m"
    delete = "30m"
  }
}