variable "report_name" {
  description = "Unique name for the report. Must start with a number/letter and is case sensitive. Limited to 256 characters."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9].*", var.report_name))
    error_message = "resource_aws_cur_report_definition, report_name must start with a number or letter."
  }

  validation {
    condition     = length(var.report_name) <= 256
    error_message = "resource_aws_cur_report_definition, report_name must be limited to 256 characters."
  }
}

variable "time_unit" {
  description = "The frequency on which report data are measured and displayed."
  type        = string

  validation {
    condition     = contains(["DAILY", "HOURLY", "MONTHLY"], var.time_unit)
    error_message = "resource_aws_cur_report_definition, time_unit must be one of: DAILY, HOURLY, MONTHLY."
  }
}

variable "format" {
  description = "Format for report."
  type        = string

  validation {
    condition     = contains(["textORcsv", "Parquet"], var.format)
    error_message = "resource_aws_cur_report_definition, format must be one of: textORcsv, Parquet."
  }
}

variable "compression" {
  description = "Compression format for report."
  type        = string

  validation {
    condition     = contains(["GZIP", "ZIP", "Parquet"], var.compression)
    error_message = "resource_aws_cur_report_definition, compression must be one of: GZIP, ZIP, Parquet."
  }
}

variable "additional_schema_elements" {
  description = "A list of schema elements."
  type        = list(string)

  validation {
    condition = alltrue([
      for element in var.additional_schema_elements : contains(["RESOURCES", "SPLIT_COST_ALLOCATION_DATA", "MANUAL_DISCOUNT_COMPATIBILITY"], element)
    ])
    error_message = "resource_aws_cur_report_definition, additional_schema_elements must contain only: RESOURCES, SPLIT_COST_ALLOCATION_DATA, MANUAL_DISCOUNT_COMPATIBILITY."
  }
}

variable "s3_bucket" {
  description = "Name of the existing S3 bucket to hold generated reports."
  type        = string
}

variable "s3_prefix" {
  description = "Report path prefix. Limited to 256 characters. May be empty but the resource can then not be modified via the AWS Console."
  type        = string

  validation {
    condition     = length(var.s3_prefix) <= 256
    error_message = "resource_aws_cur_report_definition, s3_prefix must be limited to 256 characters."
  }
}

variable "s3_region" {
  description = "Region of the existing S3 bucket to hold generated reports."
  type        = string
}

variable "additional_artifacts" {
  description = "A list of additional artifacts."
  type        = list(string)

  validation {
    condition = alltrue([
      for artifact in var.additional_artifacts : contains(["REDSHIFT", "QUICKSIGHT", "ATHENA"], artifact)
    ])
    error_message = "resource_aws_cur_report_definition, additional_artifacts must contain only: REDSHIFT, QUICKSIGHT, ATHENA."
  }

  validation {
    condition     = !(contains(var.additional_artifacts, "ATHENA") && length(var.additional_artifacts) > 1)
    error_message = "resource_aws_cur_report_definition, additional_artifacts when ATHENA exists, no other artifact type can be declared."
  }
}

variable "refresh_closed_reports" {
  description = "Set to true to update your reports after they have been finalized if AWS detects charges related to previous months."
  type        = bool
  default     = null
}

variable "report_versioning" {
  description = "Overwrite the previous version of each report or to deliver the report in addition to the previous versions."
  type        = string
  default     = null

  validation {
    condition     = var.report_versioning == null || contains(["CREATE_NEW_REPORT", "OVERWRITE_REPORT"], var.report_versioning)
    error_message = "resource_aws_cur_report_definition, report_versioning must be one of: CREATE_NEW_REPORT, OVERWRITE_REPORT."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Location."
  type        = map(string)
  default     = {}
}