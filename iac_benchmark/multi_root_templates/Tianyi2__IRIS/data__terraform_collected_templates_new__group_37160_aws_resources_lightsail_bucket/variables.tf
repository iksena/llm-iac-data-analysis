variable "name" {
  description = "Name for the bucket"
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "resource_aws_lightsail_bucket, name must not be empty."
  }
}

variable "bundle_id" {
  description = "Bundle ID to use for the bucket. A bucket bundle specifies the monthly cost, storage space, and data transfer quota for a bucket."
  type        = string

  validation {
    condition     = length(var.bundle_id) > 0
    error_message = "resource_aws_lightsail_bucket, bundle_id must not be empty."
  }
}

variable "force_delete" {
  description = "Whether to force delete non-empty buckets using terraform destroy. AWS by default will not delete a bucket which is not empty, to prevent losing bucket data and affecting other resources in Lightsail."
  type        = bool
  default     = false
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. To create a key-only tag, use an empty string as the value."
  type        = map(string)
  default     = {}
}