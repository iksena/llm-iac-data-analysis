variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "resource_policy" {
  description = "Amazon Web Services resource-based policy document in JSON format."
  type        = string

  validation {
    condition     = can(jsondecode(var.resource_policy))
    error_message = "resource_aws_s3tables_table_policy, resource_policy must be a valid JSON string."
  }
}

variable "name" {
  description = "Name of the table. Must be between 1 and 255 characters in length. Can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_s3tables_table_policy, name must be between 1 and 255 characters in length."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9_]*[a-z0-9]$|^[a-z0-9]$", var.name))
    error_message = "resource_aws_s3tables_table_policy, name can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  }
}

variable "namespace" {
  description = "Name of the namespace for this table. Must be between 1 and 255 characters in length. Can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  type        = string

  validation {
    condition     = length(var.namespace) >= 1 && length(var.namespace) <= 255
    error_message = "resource_aws_s3tables_table_policy, namespace must be between 1 and 255 characters in length."
  }

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9_]*[a-z0-9]$|^[a-z0-9]$", var.namespace))
    error_message = "resource_aws_s3tables_table_policy, namespace can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  }
}

variable "table_bucket_arn" {
  description = "ARN referencing the Table Bucket that contains this Namespace."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3tables:", var.table_bucket_arn))
    error_message = "resource_aws_s3tables_table_policy, table_bucket_arn must be a valid S3 Tables bucket ARN."
  }
}