variable "format" {
  description = "Format of the table. Must be ICEBERG."
  type        = string
  validation {
    condition     = var.format == "ICEBERG"
    error_message = "resource_aws_s3tables_table, format must be 'ICEBERG'."
  }
}

variable "name" {
  description = "Name of the table. Must be between 1 and 255 characters in length. Can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9_]*[a-z0-9]$", var.name)) && length(var.name) >= 1 && length(var.name) <= 255
    error_message = "resource_aws_s3tables_table, name must be between 1 and 255 characters in length, consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  }
}

variable "namespace" {
  description = "Name of the namespace for this table. Must be between 1 and 255 characters in length. Can consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9_]*[a-z0-9]$", var.namespace)) && length(var.namespace) >= 1 && length(var.namespace) <= 255
    error_message = "resource_aws_s3tables_table, namespace must be between 1 and 255 characters in length, consist of lowercase letters, numbers, and underscores, and must begin and end with a lowercase letter or number."
  }
}

variable "table_bucket_arn" {
  description = "ARN referencing the Table Bucket that contains this Namespace. Forces new resource."
  type        = string
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}


variable "metadata" {
  description = "Contains details about the table metadata. This configuration specifies the metadata format and schema for the table. Currently only supports Iceberg format."
  type = object({
    iceberg = optional(object({
      schema = object({
        fields = list(object({
          name     = string
          type     = string
          required = optional(bool, false)
        }))
      })
    }))
  })
  default = null
}