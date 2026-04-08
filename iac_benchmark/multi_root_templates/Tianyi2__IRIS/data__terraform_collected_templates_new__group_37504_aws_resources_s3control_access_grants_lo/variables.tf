variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.region))
    error_message = "resource_aws_s3control_access_grants_location, region must be a valid AWS region format (e.g., us-east-1, eu-west-1) or null."
  }
}

variable "account_id" {
  description = "The AWS account ID for the S3 Access Grants location. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3control_access_grants_location, account_id must be a 12-digit AWS account ID or null."
  }
}

variable "iam_role_arn" {
  description = "The ARN of the IAM role that S3 Access Grants should use when fulfilling runtime access requests to the location."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/.+", var.iam_role_arn))
    error_message = "resource_aws_s3control_access_grants_location, iam_role_arn must be a valid IAM role ARN (e.g., arn:aws:iam::123456789012:role/RoleName)."
  }
}

variable "location_scope" {
  description = "The default S3 URI s3:// or the URI to a custom location, a specific bucket or prefix."
  type        = string

  validation {
    condition     = can(regex("^s3://", var.location_scope))
    error_message = "resource_aws_s3control_access_grants_location, location_scope must be a valid S3 URI starting with 's3://'."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_s3control_access_grants_location, tags keys must be 1-128 characters and values must be 0-256 characters."
  }
}