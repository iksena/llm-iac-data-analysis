variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_s3control_access_grants_instance, region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "account_id" {
  description = "The AWS account ID for the S3 Access Grants instance. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3control_access_grants_instance, account_id must be a 12-digit AWS account ID."
  }
}

variable "identity_center_arn" {
  description = "The ARN of the AWS IAM Identity Center instance associated with the S3 Access Grants instance."
  type        = string
  default     = null

  validation {
    condition     = var.identity_center_arn == null || can(regex("^arn:aws:sso:::instance/ssoins-[a-f0-9]{16}$", var.identity_center_arn))
    error_message = "resource_aws_s3control_access_grants_instance, identity_center_arn must be a valid AWS IAM Identity Center instance ARN."
  }
}

variable "tags" {
  description = "Key-value map of resource tags. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{1,128}$", k))
    ])
    error_message = "resource_aws_s3control_access_grants_instance, tags keys must be between 1 and 128 characters."
  }

  validation {
    condition = alltrue([
      for k, v in var.tags : can(regex("^.{0,256}$", v))
    ])
    error_message = "resource_aws_s3control_access_grants_instance, tags values must be between 0 and 256 characters."
  }
}