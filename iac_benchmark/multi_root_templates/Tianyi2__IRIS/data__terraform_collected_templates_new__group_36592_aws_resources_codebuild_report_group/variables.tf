variable "name" {
  description = "The name of a Report Group."
  type        = string
}

variable "type" {
  description = "The type of the Report Group. Valid value are TEST and CODE_COVERAGE."
  type        = string
  validation {
    condition     = contains(["TEST", "CODE_COVERAGE"], var.type)
    error_message = "resource_aws_codebuild_report_group, type must be either 'TEST' or 'CODE_COVERAGE'."
  }
}

variable "export_config" {
  description = "Information about the destination where the raw data of this Report Group is exported."
  type = object({
    type = string
    s3_destination = optional(object({
      bucket              = string
      encryption_key      = string
      encryption_disabled = optional(bool, null)
      packaging           = optional(string, "NONE")
      path                = optional(string)
    }))
  })
  validation {
    condition     = contains(["S3", "NO_EXPORT"], var.export_config.type)
    error_message = "resource_aws_codebuild_report_group, export_config.type must be either 'S3' or 'NO_EXPORT'."
  }
  validation {
    condition     = var.export_config.type == "S3" ? var.export_config.s3_destination != null : true
    error_message = "resource_aws_codebuild_report_group, export_config.s3_destination is required when export_config.type is 'S3'."
  }
  validation {
    condition = (
      var.export_config.s3_destination != null ?
      contains(["NONE", "ZIP"], coalesce(var.export_config.s3_destination.packaging, "NONE")) :
      true
    )
    error_message = "resource_aws_codebuild_report_group, export_config.s3_destination.packaging must be either 'NONE' or 'ZIP'."
  }
}

variable "delete_reports" {
  description = "If true, deletes any reports that belong to a report group before deleting the report group. If false, you must delete any reports in the report group before deleting it."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Key-value mapping of resource tags."
  type        = map(string)
  default     = {}
}