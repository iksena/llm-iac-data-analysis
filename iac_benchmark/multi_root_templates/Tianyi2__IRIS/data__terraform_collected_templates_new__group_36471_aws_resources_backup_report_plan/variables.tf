variable "name" {
  description = "The unique name of the report plan. The name must be between 1 and 256 characters, starting with a letter, and consisting of letters, numbers, and underscores."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 256
    error_message = "resource_aws_backup_report_plan, name must be between 1 and 256 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]*$", var.name))
    error_message = "resource_aws_backup_report_plan, name must start with a letter and consist of letters, numbers, and underscores."
  }
}

variable "description" {
  description = "The description of the report plan with a maximum of 1,024 characters"
  type        = string
  default     = null

  validation {
    condition     = var.description == null || length(var.description) <= 1024
    error_message = "resource_aws_backup_report_plan, description must be maximum 1,024 characters."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "report_delivery_channel_formats" {
  description = "A list of the format of your reports: CSV, JSON, or both. If not specified, the default format is CSV."
  type        = list(string)
  default     = ["CSV"]

  validation {
    condition = alltrue([
      for format in var.report_delivery_channel_formats : contains(["CSV", "JSON"], format)
    ])
    error_message = "resource_aws_backup_report_plan, report_delivery_channel_formats must contain only 'CSV' or 'JSON' values."
  }
}

variable "report_delivery_channel_s3_bucket_name" {
  description = "The unique name of the S3 bucket that receives your reports."
  type        = string
}

variable "report_delivery_channel_s3_key_prefix" {
  description = "The prefix for where Backup Audit Manager delivers your reports to Amazon S3. The prefix is this part of the following path: s3://your-bucket-name/prefix/Backup/us-west-2/year/month/day/report-name. If not specified, there is no prefix."
  type        = string
  default     = null
}

variable "report_setting_report_template" {
  description = "Identifies the report template for the report. Reports are built using a report template."
  type        = string

  validation {
    condition = contains([
      "RESOURCE_COMPLIANCE_REPORT",
      "CONTROL_COMPLIANCE_REPORT",
      "BACKUP_JOB_REPORT",
      "COPY_JOB_REPORT",
      "RESTORE_JOB_REPORT"
    ], var.report_setting_report_template)
    error_message = "resource_aws_backup_report_plan, report_setting_report_template must be one of: RESOURCE_COMPLIANCE_REPORT, CONTROL_COMPLIANCE_REPORT, BACKUP_JOB_REPORT, COPY_JOB_REPORT, RESTORE_JOB_REPORT."
  }
}

variable "report_setting_accounts" {
  description = "Specifies the list of accounts a report covers."
  type        = list(string)
  default     = null
}

variable "report_setting_framework_arns" {
  description = "Specifies the Amazon Resource Names (ARNs) of the frameworks a report covers."
  type        = list(string)
  default     = null
}

variable "report_setting_number_of_frameworks" {
  description = "Specifies the number of frameworks a report covers."
  type        = number
  default     = null

  validation {
    condition     = var.report_setting_number_of_frameworks == null || var.report_setting_number_of_frameworks >= 0
    error_message = "resource_aws_backup_report_plan, report_setting_number_of_frameworks must be a non-negative number."
  }
}

variable "report_setting_organization_units" {
  description = "Specifies the list of Organizational Units a report covers."
  type        = list(string)
  default     = null
}

variable "report_setting_regions" {
  description = "Specifies the list of regions a report covers."
  type        = list(string)
  default     = null
}

variable "tags" {
  description = "Metadata that you can assign to help organize the report plans you create. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}