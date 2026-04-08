variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "The Amazon S3 bucket in which to store the Spot instance data feed."
  type        = string

  validation {
    condition     = var.bucket != null && var.bucket != ""
    error_message = "resource_aws_spot_datafeed_subscription, bucket must be a non-empty string."
  }
}

variable "prefix" {
  description = "Path of folder inside bucket to place spot pricing data."
  type        = string
  default     = null
}