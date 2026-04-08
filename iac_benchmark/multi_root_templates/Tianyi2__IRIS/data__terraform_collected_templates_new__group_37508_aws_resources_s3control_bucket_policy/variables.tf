variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "bucket" {
  description = "Amazon Resource Name (ARN) of the bucket."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3-outposts:", var.bucket))
    error_message = "resource_aws_s3control_bucket_policy, bucket must be a valid S3 Outposts bucket ARN starting with 'arn:aws:s3-outposts:'."
  }
}

variable "policy" {
  description = "JSON string of the resource policy."
  type        = string

  validation {
    condition     = can(jsondecode(var.policy))
    error_message = "resource_aws_s3control_bucket_policy, policy must be a valid JSON string."
  }
}