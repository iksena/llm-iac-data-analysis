variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "name" {
  description = "Name of the table."
  type        = string

  validation {
    condition     = length(var.name) > 0
    error_message = "data_aws_glue_catalog_table, name must not be empty."
  }
}

variable "database_name" {
  description = "Name of the metadata database where the table metadata resides."
  type        = string

  validation {
    condition     = length(var.database_name) > 0
    error_message = "data_aws_glue_catalog_table, database_name must not be empty."
  }
}

variable "catalog_id" {
  description = "ID of the Glue Catalog and database where the table metadata resides. If omitted, this defaults to the current AWS Account ID."
  type        = string
  default     = null
}

variable "query_as_of_time" {
  description = "The time as of when to read the table contents. If not set, the most recent transaction commit time will be used. Cannot be specified along with transaction_id. Specified in RFC 3339 format, e.g. 2006-01-02T15:04:05Z07:00."
  type        = string
  default     = null

  validation {
    condition     = var.query_as_of_time == null ? true : can(formatdate("RFC3339", var.query_as_of_time))
    error_message = "data_aws_glue_catalog_table, query_as_of_time must be in RFC 3339 format."
  }

  validation {
    condition     = var.query_as_of_time == null || var.transaction_id == null
    error_message = "data_aws_glue_catalog_table, query_as_of_time cannot be specified along with transaction_id."
  }
}

variable "transaction_id" {
  description = "The transaction ID at which to read the table contents."
  type        = string
  default     = null
}