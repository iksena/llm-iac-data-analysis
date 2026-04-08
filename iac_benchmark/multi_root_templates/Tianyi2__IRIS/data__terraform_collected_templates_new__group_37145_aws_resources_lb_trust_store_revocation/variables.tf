variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_lb_trust_store_revocation, region must be a valid AWS region format."
  }
}

variable "trust_store_arn" {
  description = "Trust Store ARN."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:elasticloadbalancing:[a-z0-9-]+:[0-9]+:truststore/.+", var.trust_store_arn))
    error_message = "resource_aws_lb_trust_store_revocation, trust_store_arn must be a valid Trust Store ARN."
  }
}

variable "revocations_s3_bucket" {
  description = "S3 Bucket name holding the client certificate CA bundle."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.revocations_s3_bucket)) && length(var.revocations_s3_bucket) >= 3 && length(var.revocations_s3_bucket) <= 63
    error_message = "resource_aws_lb_trust_store_revocation, revocations_s3_bucket must be a valid S3 bucket name (3-63 characters, lowercase letters, numbers, dots, and hyphens)."
  }
}

variable "revocations_s3_key" {
  description = "S3 object key holding the client certificate CA bundle."
  type        = string

  validation {
    condition     = length(var.revocations_s3_key) > 0 && length(var.revocations_s3_key) <= 1024
    error_message = "resource_aws_lb_trust_store_revocation, revocations_s3_key must be between 1 and 1024 characters."
  }
}

variable "revocations_s3_object_version" {
  description = "Version Id of CA bundle S3 bucket object, if versioned, defaults to latest if omitted."
  type        = string
  default     = null

  validation {
    condition     = var.revocations_s3_object_version == null || length(var.revocations_s3_object_version) > 0
    error_message = "resource_aws_lb_trust_store_revocation, revocations_s3_object_version must not be empty if provided."
  }
}