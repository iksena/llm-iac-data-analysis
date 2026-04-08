variable "export_name" {
  description = "Name of this specific data export"
  type        = string

  validation {
    condition     = length(var.export_name) > 0
    error_message = "resource_aws_bcmdataexports_export, export_name must not be empty."
  }
}

variable "export_description" {
  description = "Description for this specific data export"
  type        = string
  default     = null
}

variable "data_query_statement" {
  description = "Query statement. The SQL table name for CUR 2.0 is COST_AND_USAGE_REPORT"
  type        = string

  validation {
    condition     = length(var.data_query_statement) > 0
    error_message = "resource_aws_bcmdataexports_export, data_query_statement must not be empty."
  }
}

variable "data_query_table_configurations" {
  description = "Table configuration. See the AWS documentation for the available configurations. BILLING_VIEW_ARN must also be included"
  type        = map(map(string))
  default     = null
}

variable "s3_bucket" {
  description = "Name of the Amazon S3 bucket used as the destination of a data export file"
  type        = string

  validation {
    condition     = length(var.s3_bucket) > 0
    error_message = "resource_aws_bcmdataexports_export, s3_bucket must not be empty."
  }
}

variable "s3_prefix" {
  description = "S3 path prefix you want prepended to the name of your data export"
  type        = string

  validation {
    condition     = length(var.s3_prefix) > 0
    error_message = "resource_aws_bcmdataexports_export, s3_prefix must not be empty."
  }
}

variable "s3_region" {
  description = "S3 bucket region"
  type        = string

  validation {
    condition     = length(var.s3_region) > 0
    error_message = "resource_aws_bcmdataexports_export, s3_region must not be empty."
  }
}

variable "s3_output_compression" {
  description = "Compression type for the data export"
  type        = string

  validation {
    condition     = contains(["GZIP", "PARQUET"], var.s3_output_compression)
    error_message = "resource_aws_bcmdataexports_export, s3_output_compression must be one of: GZIP, PARQUET."
  }
}

variable "s3_output_format" {
  description = "File format for the data export"
  type        = string

  validation {
    condition     = contains(["TEXT_OR_CSV", "PARQUET"], var.s3_output_format)
    error_message = "resource_aws_bcmdataexports_export, s3_output_format must be one of: TEXT_OR_CSV, PARQUET."
  }
}

variable "s3_output_type" {
  description = "Output type for the data export"
  type        = string
  default     = "CUSTOM"

  validation {
    condition     = var.s3_output_type == "CUSTOM"
    error_message = "resource_aws_bcmdataexports_export, s3_output_type must be CUSTOM."
  }
}

variable "s3_output_overwrite" {
  description = "The rule to follow when generating a version of the data export file"
  type        = string

  validation {
    condition     = contains(["CREATE_NEW_REPORT", "OVERWRITE_REPORT"], var.s3_output_overwrite)
    error_message = "resource_aws_bcmdataexports_export, s3_output_overwrite must be one of: CREATE_NEW_REPORT, OVERWRITE_REPORT."
  }
}

variable "refresh_cadence_frequency" {
  description = "Frequency that data exports are updated"
  type        = string
  default     = "SYNCHRONOUS"

  validation {
    condition     = var.refresh_cadence_frequency == "SYNCHRONOUS"
    error_message = "resource_aws_bcmdataexports_export, refresh_cadence_frequency must be SYNCHRONOUS."
  }
}

variable "timeout_create" {
  description = "Timeout for resource creation"
  type        = string
  default     = "30m"
}

variable "timeout_update" {
  description = "Timeout for resource update"
  type        = string
  default     = "30m"
}