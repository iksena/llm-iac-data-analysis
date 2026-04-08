variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "namespace" {
  description = "Name of the namespace. Must be between 1 and 255 characters in length. Can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  type        = string

  validation {
    condition     = length(var.namespace) >= 1 && length(var.namespace) <= 255
    error_message = "resource_aws_s3tables_namespace, namespace must be between 1 and 255 characters in length."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9_]*[a-z0-9]$", var.namespace)) || can(regex("^[a-z0-9]$", var.namespace))
    error_message = "resource_aws_s3tables_namespace, namespace can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  }
}

variable "table_bucket_arn" {
  description = "ARN referencing the Table Bucket that contains this Namespace."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3tables:", var.table_bucket_arn))
    error_message = "resource_aws_s3tables_namespace, table_bucket_arn must be a valid S3 Tables bucket ARN."
  }
}