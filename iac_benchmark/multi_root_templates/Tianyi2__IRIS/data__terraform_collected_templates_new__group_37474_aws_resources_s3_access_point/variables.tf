variable "bucket" {
  description = "Name of an AWS Partition S3 General Purpose Bucket or the ARN of S3 on Outposts Bucket that you want to associate this access point with."
  type        = string
}

variable "name" {
  description = "Name you want to assign to this access point."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9\\-]{1,61}[a-z0-9]$", var.name))
    error_message = "resource_aws_s3_access_point, name must be between 3 and 63 characters, start and end with lowercase letters or numbers, and contain only lowercase letters, numbers, and hyphens."
  }
}

variable "account_id" {
  description = "AWS account ID for the owner of the bucket for which you want to create an access point. Defaults to automatically determined account ID of the Terraform AWS provider."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "resource_aws_s3_access_point, account_id must be a 12-digit AWS account ID."
  }
}

variable "bucket_account_id" {
  description = "AWS account ID associated with the S3 bucket associated with this access point."
  type        = string
  default     = null

  validation {
    condition     = var.bucket_account_id == null || can(regex("^[0-9]{12}$", var.bucket_account_id))
    error_message = "resource_aws_s3_access_point, bucket_account_id must be a 12-digit AWS account ID."
  }
}

variable "policy" {
  description = "Valid JSON document that specifies the policy that you want to apply to this access point."
  type        = string
  default     = null

  validation {
    condition     = var.policy == null || can(jsondecode(var.policy))
    error_message = "resource_aws_s3_access_point, policy must be a valid JSON document."
  }
}

variable "public_access_block_configuration" {
  description = "Configuration block to manage the PublicAccessBlock configuration that you want to apply to this Amazon S3 bucket."
  type = object({
    block_public_acls       = optional(bool, true)
    block_public_policy     = optional(bool, true)
    ignore_public_acls      = optional(bool, true)
    restrict_public_buckets = optional(bool, true)
  })
  default = null

  validation {
    condition = var.public_access_block_configuration == null || (
      var.public_access_block_configuration.block_public_acls != null &&
      var.public_access_block_configuration.block_public_policy != null &&
      var.public_access_block_configuration.ignore_public_acls != null &&
      var.public_access_block_configuration.restrict_public_buckets != null
    )
    error_message = "resource_aws_s3_access_point, public_access_block_configuration all boolean values must be specified when configuration block is provided."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_s3_access_point, region must be a valid AWS region identifier."
  }
}

variable "tags" {
  description = "Map of tags to assign to the bucket."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k, v in var.tags : can(regex("^.{1,128}$", k)) && can(regex("^.{0,256}$", v))])
    error_message = "resource_aws_s3_access_point, tags keys must be between 1-128 characters and values must be between 0-256 characters."
  }
}

variable "vpc_configuration" {
  description = "Configuration block to restrict access to this access point to requests from the specified Virtual Private Cloud (VPC). Required for S3 on Outposts."
  type = object({
    vpc_id = string
  })
  default = null

  validation {
    condition     = var.vpc_configuration == null || can(regex("^vpc-[a-z0-9]+$", var.vpc_configuration.vpc_id))
    error_message = "resource_aws_s3_access_point, vpc_configuration.vpc_id must be a valid VPC ID starting with 'vpc-'."
  }
}