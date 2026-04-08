variable "name" {
  description = "A name that identifies the Origin Access Control."
  type        = string
}

variable "description" {
  description = "The description of the Origin Access Control."
  type        = string
  default     = "Managed by Terraform"
}

variable "origin_access_control_origin_type" {
  description = "The type of origin that this Origin Access Control is for."
  type        = string

  validation {
    condition     = contains(["lambda", "mediapackagev2", "mediastore", "s3"], var.origin_access_control_origin_type)
    error_message = "resource_aws_cloudfront_origin_access_control, origin_access_control_origin_type must be one of: lambda, mediapackagev2, mediastore, s3."
  }
}

variable "signing_behavior" {
  description = "Specifies which requests CloudFront signs."
  type        = string

  validation {
    condition     = contains(["always", "never", "no-override"], var.signing_behavior)
    error_message = "resource_aws_cloudfront_origin_access_control, signing_behavior must be one of: always, never, no-override."
  }
}

variable "signing_protocol" {
  description = "Determines how CloudFront signs (authenticates) requests."
  type        = string

  validation {
    condition     = var.signing_protocol == "sigv4"
    error_message = "resource_aws_cloudfront_origin_access_control, signing_protocol must be sigv4."
  }
}