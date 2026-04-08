variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "bucket" {
  description = "Name of the bucket. The name must be in the format [bucket_name]--[azid]--x-s3"
  type        = string

  validation {
    condition     = can(regex("^.+--[a-z0-9-]+--x-s3$", var.bucket))
    error_message = "resource_aws_s3_directory_bucket, bucket must be in the format [bucket_name]--[azid]--x-s3."
  }
}

variable "data_redundancy" {
  description = "Data redundancy. Valid values: SingleAvailabilityZone, SingleLocalZone"
  type        = string
  default     = null

  validation {
    condition     = var.data_redundancy == null || contains(["SingleAvailabilityZone", "SingleLocalZone"], var.data_redundancy)
    error_message = "resource_aws_s3_directory_bucket, data_redundancy must be one of: SingleAvailabilityZone, SingleLocalZone."
  }
}

variable "force_destroy" {
  description = "Boolean that indicates all objects should be deleted from the bucket when the bucket is destroyed"
  type        = bool
  default     = false
}

variable "location" {
  description = "Bucket location configuration"
  type = object({
    name = string
    type = optional(string, "AvailabilityZone")
  })

  validation {
    condition     = contains(["AvailabilityZone", "LocalZone"], var.location.type)
    error_message = "resource_aws_s3_directory_bucket, location.type must be one of: AvailabilityZone, LocalZone."
  }
}

variable "tags" {
  description = "Map of tags to assign to the bucket"
  type        = map(string)
  default     = {}
}

variable "type" {
  description = "Bucket type. Valid values: Directory"
  type        = string
  default     = "Directory"

  validation {
    condition     = var.type == "Directory"
    error_message = "resource_aws_s3_directory_bucket, type must be Directory."
  }
}