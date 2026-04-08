variable "name" {
  description = "Name of the Trust Store. If omitted, Terraform will assign a random, unique name. This name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  type        = string
  default     = null

  validation {
    condition = var.name == null || (
      length(var.name) <= 32 &&
      can(regex("^[a-zA-Z0-9-]*$", var.name)) &&
      !can(regex("^-", var.name)) &&
      !can(regex("-$", var.name))
    )
    error_message = "resource_aws_lb_trust_store, name must be unique per region per account, can have a maximum of 32 characters, must contain only alphanumeric characters or hyphens, and must not begin or end with a hyphen."
  }
}

variable "name_prefix" {
  description = "Creates a unique name beginning with the specified prefix. Conflicts with name. Cannot be longer than 6 characters."
  type        = string
  default     = null

  validation {
    condition     = var.name_prefix == null || length(var.name_prefix) <= 6
    error_message = "resource_aws_lb_trust_store, name_prefix cannot be longer than 6 characters."
  }
}

variable "ca_certificates_bundle_s3_bucket" {
  description = "S3 Bucket name holding the client certificate CA bundle."
  type        = string
}

variable "ca_certificates_bundle_s3_key" {
  description = "S3 object key holding the client certificate CA bundle."
  type        = string
}

variable "ca_certificates_bundle_s3_object_version" {
  description = "Version Id of CA bundle S3 bucket object, if versioned, defaults to latest if omitted."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}