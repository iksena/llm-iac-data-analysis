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
    error_message = "resource_aws_s3tables_table_bucket_policy, resource_policy must be a valid JSON string."
  }
}

variable "table_bucket_arn" {
  description = "ARN referencing the Table Bucket that owns this policy."
  type        = string

  validation {
    condition     = can(regex("^arn:aws:s3tables:", var.table_bucket_arn))
    error_message = "resource_aws_s3tables_table_bucket_policy, table_bucket_arn must be a valid S3 Tables Table Bucket ARN starting with 'arn:aws:s3tables:'."
  }
}