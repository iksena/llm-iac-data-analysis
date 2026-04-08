variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "agent_arns" {
  description = "(Amazon S3 on Outposts only) Amazon Resource Name (ARN) of the DataSync agent on the Outpost."
  type        = list(string)
  default     = null

  validation {
    condition = var.agent_arns == null || alltrue([
      for arn in var.agent_arns : can(regex("^arn:aws[a-zA-Z-]*:datasync:[a-z0-9-]+:[0-9]{12}:agent/agent-[0-9a-fA-F]+$", arn))
    ])
    error_message = "resource_aws_datasync_location_s3, agent_arns must be valid DataSync agent ARNs."
  }
}

variable "s3_bucket_arn" {
  description = "Amazon Resource Name (ARN) of the S3 bucket, or the Amazon S3 access point if the S3 bucket is located on an AWS Outposts resource."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:s3[a-zA-Z-]*:[a-z0-9-]*:[0-9]{12}:|^arn:aws[a-zA-Z-]*:s3:::", var.s3_bucket_arn))
    error_message = "resource_aws_datasync_location_s3, s3_bucket_arn must be a valid S3 bucket or access point ARN."
  }
}

variable "s3_config_bucket_access_role_arn" {
  description = "ARN of the IAM Role used to connect to the S3 Bucket."
  type        = string

  validation {
    condition     = can(regex("^arn:aws[a-zA-Z-]*:iam::[0-9]{12}:role/", var.s3_config_bucket_access_role_arn))
    error_message = "resource_aws_datasync_location_s3, s3_config_bucket_access_role_arn must be a valid IAM role ARN."
  }
}

variable "s3_storage_class" {
  description = "Amazon S3 storage class that you want to store your files in when this location is used as a task destination."
  type        = string
  default     = null

  validation {
    condition = var.s3_storage_class == null || contains([
      "STANDARD", "STANDARD_IA", "ONEZONE_IA", "REDUCED_REDUNDANCY",
      "GLACIER", "GLACIER_IR", "DEEP_ARCHIVE", "OUTPOSTS"
    ], var.s3_storage_class)
    error_message = "resource_aws_datasync_location_s3, s3_storage_class must be one of: STANDARD, STANDARD_IA, ONEZONE_IA, REDUCED_REDUNDANCY, GLACIER, GLACIER_IR, DEEP_ARCHIVE, or OUTPOSTS."
  }
}

variable "subdirectory" {
  description = "Prefix to perform actions as source or destination."
  type        = string

  validation {
    condition     = can(regex("^/", var.subdirectory))
    error_message = "resource_aws_datasync_location_s3, subdirectory must start with a forward slash (/)."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location."
  type        = map(string)
  default     = {}
}