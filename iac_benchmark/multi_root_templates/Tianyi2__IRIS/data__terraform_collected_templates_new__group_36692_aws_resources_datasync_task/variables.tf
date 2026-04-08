variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "destination_location_arn" {
  description = "Amazon Resource Name (ARN) of destination DataSync Location"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:datasync:[a-z0-9-]+:[0-9]{12}:location/loc-[a-f0-9]+$", var.destination_location_arn))
    error_message = "resource_aws_datasync_task, destination_location_arn must be a valid DataSync location ARN."
  }
}

variable "source_location_arn" {
  description = "Amazon Resource Name (ARN) of source DataSync Location"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:datasync:[a-z0-9-]+:[0-9]{12}:location/loc-[a-f0-9]+$", var.source_location_arn))
    error_message = "resource_aws_datasync_task, source_location_arn must be a valid DataSync location ARN."
  }
}

variable "cloudwatch_log_group_arn" {
  description = "Amazon Resource Name (ARN) of the CloudWatch Log Group that is used to monitor and log events in the sync task"
  type        = string
  default     = null

  validation {
    condition     = var.cloudwatch_log_group_arn == null || can(regex("^arn:aws:logs:[a-z0-9-]+:[0-9]{12}:log-group:", var.cloudwatch_log_group_arn))
    error_message = "resource_aws_datasync_task, cloudwatch_log_group_arn must be a valid CloudWatch log group ARN."
  }
}

variable "name" {
  description = "Name of the DataSync Task"
  type        = string
  default     = null
}

variable "task_mode" {
  description = "Task mode for your data transfer: BASIC or ENHANCED"
  type        = string
  default     = "BASIC"

  validation {
    condition     = contains(["BASIC", "ENHANCED"], var.task_mode)
    error_message = "resource_aws_datasync_task, task_mode must be either BASIC or ENHANCED."
  }
}

variable "excludes" {
  description = "Filter rules that determines which files to exclude from a task"
  type = object({
    filter_type = optional(string)
    value       = optional(string)
  })
  default = null

  validation {
    condition = var.excludes == null || (
      var.excludes.filter_type == null || contains(["SIMPLE_PATTERN"], var.excludes.filter_type)
    )
    error_message = "resource_aws_datasync_task, excludes filter_type must be SIMPLE_PATTERN."
  }
}

variable "includes" {
  description = "Filter rules that determines which files to include in a task"
  type = object({
    filter_type = optional(string)
    value       = optional(string)
  })
  default = null

  validation {
    condition = var.includes == null || (
      var.includes.filter_type == null || contains(["SIMPLE_PATTERN"], var.includes.filter_type)
    )
    error_message = "resource_aws_datasync_task, includes filter_type must be SIMPLE_PATTERN."
  }
}

variable "options" {
  description = "Configuration block containing option that controls the default behavior when you start an execution of this DataSync Task"
  type = object({
    atime                          = optional(string)
    bytes_per_second               = optional(number)
    gid                            = optional(string)
    log_level                      = optional(string)
    mtime                          = optional(string)
    object_tags                    = optional(string)
    overwrite_mode                 = optional(string)
    posix_permissions              = optional(string)
    preserve_deleted_files         = optional(string)
    preserve_devices               = optional(string)
    security_descriptor_copy_flags = optional(string)
    task_queueing                  = optional(string)
    transfer_mode                  = optional(string)
    uid                            = optional(string)
    verify_mode                    = optional(string)
  })
  default = null

  validation {
    condition = var.options == null || (
      var.options.atime == null || contains(["BEST_EFFORT", "NONE"], var.options.atime)
    )
    error_message = "resource_aws_datasync_task, options atime must be BEST_EFFORT or NONE."
  }

  validation {
    condition = var.options == null || (
      var.options.bytes_per_second == null || var.options.bytes_per_second >= -1
    )
    error_message = "resource_aws_datasync_task, options bytes_per_second must be -1 or greater."
  }

  validation {
    condition = var.options == null || (
      var.options.gid == null || contains(["BOTH", "INT_VALUE", "NAME", "NONE"], var.options.gid)
    )
    error_message = "resource_aws_datasync_task, options gid must be BOTH, INT_VALUE, NAME, or NONE."
  }

  validation {
    condition = var.options == null || (
      var.options.log_level == null || contains(["OFF", "BASIC", "TRANSFER"], var.options.log_level)
    )
    error_message = "resource_aws_datasync_task, options log_level must be OFF, BASIC, or TRANSFER."
  }

  validation {
    condition = var.options == null || (
      var.options.mtime == null || contains(["NONE", "PRESERVE"], var.options.mtime)
    )
    error_message = "resource_aws_datasync_task, options mtime must be NONE or PRESERVE."
  }

  validation {
    condition = var.options == null || (
      var.options.object_tags == null || contains(["PRESERVE", "NONE"], var.options.object_tags)
    )
    error_message = "resource_aws_datasync_task, options object_tags must be PRESERVE or NONE."
  }

  validation {
    condition = var.options == null || (
      var.options.overwrite_mode == null || contains(["ALWAYS", "NEVER"], var.options.overwrite_mode)
    )
    error_message = "resource_aws_datasync_task, options overwrite_mode must be ALWAYS or NEVER."
  }

  validation {
    condition = var.options == null || (
      var.options.posix_permissions == null || contains(["NONE", "PRESERVE"], var.options.posix_permissions)
    )
    error_message = "resource_aws_datasync_task, options posix_permissions must be NONE or PRESERVE."
  }

  validation {
    condition = var.options == null || (
      var.options.preserve_deleted_files == null || contains(["PRESERVE", "REMOVE"], var.options.preserve_deleted_files)
    )
    error_message = "resource_aws_datasync_task, options preserve_deleted_files must be PRESERVE or REMOVE."
  }

  validation {
    condition = var.options == null || (
      var.options.preserve_devices == null || contains(["NONE", "PRESERVE"], var.options.preserve_devices)
    )
    error_message = "resource_aws_datasync_task, options preserve_devices must be NONE or PRESERVE."
  }

  validation {
    condition = var.options == null || (
      var.options.security_descriptor_copy_flags == null || contains(["NONE", "OWNER_DACL", "OWNER_DACL_SACL"], var.options.security_descriptor_copy_flags)
    )
    error_message = "resource_aws_datasync_task, options security_descriptor_copy_flags must be NONE, OWNER_DACL, or OWNER_DACL_SACL."
  }

  validation {
    condition = var.options == null || (
      var.options.task_queueing == null || contains(["ENABLED", "DISABLED"], var.options.task_queueing)
    )
    error_message = "resource_aws_datasync_task, options task_queueing must be ENABLED or DISABLED."
  }

  validation {
    condition = var.options == null || (
      var.options.transfer_mode == null || contains(["CHANGED", "ALL"], var.options.transfer_mode)
    )
    error_message = "resource_aws_datasync_task, options transfer_mode must be CHANGED or ALL."
  }

  validation {
    condition = var.options == null || (
      var.options.uid == null || contains(["BOTH", "INT_VALUE", "NAME", "NONE"], var.options.uid)
    )
    error_message = "resource_aws_datasync_task, options uid must be BOTH, INT_VALUE, NAME, or NONE."
  }

  validation {
    condition = var.options == null || (
      var.options.verify_mode == null || contains(["NONE", "POINT_IN_TIME_CONSISTENT", "ONLY_FILES_TRANSFERRED"], var.options.verify_mode)
    )
    error_message = "resource_aws_datasync_task, options verify_mode must be NONE, POINT_IN_TIME_CONSISTENT, or ONLY_FILES_TRANSFERRED."
  }

  validation {
    condition = var.options == null || (
      (var.options.atime != "BEST_EFFORT" || var.options.mtime == "PRESERVE" || var.options.mtime == null) &&
      (var.options.atime != "NONE" || var.options.mtime == "NONE" || var.options.mtime == null)
    )
    error_message = "resource_aws_datasync_task, options if atime is BEST_EFFORT then mtime must be PRESERVE, if atime is NONE then mtime must be NONE."
  }
}

variable "schedule" {
  description = "Specifies a schedule used to periodically transfer files from a source to a destination location"
  type = object({
    schedule_expression = string
  })
  default = null
}

variable "task_report_config" {
  description = "Configuration block containing the configuration of a DataSync Task Report"
  type = object({
    s3_object_versioning = optional(string)
    output_type          = optional(string)
    report_level         = string
    s3_destination = object({
      bucket_access_role_arn = string
      s3_bucket_arn          = string
      subdirectory           = optional(string)
    })
    report_overrides = optional(object({
      deleted_override     = optional(string)
      skipped_override     = optional(string)
      transferred_override = optional(string)
      verified_override    = optional(string)
    }))
  })
  default = null

  validation {
    condition = var.task_report_config == null || (
      var.task_report_config.s3_object_versioning == null || contains(["INCLUDE", "NONE"], var.task_report_config.s3_object_versioning)
    )
    error_message = "resource_aws_datasync_task, task_report_config s3_object_versioning must be INCLUDE or NONE."
  }

  validation {
    condition = var.task_report_config == null || (
      var.task_report_config.output_type == null || contains(["SUMMARY_ONLY", "STANDARD"], var.task_report_config.output_type)
    )
    error_message = "resource_aws_datasync_task, task_report_config output_type must be SUMMARY_ONLY or STANDARD."
  }

  validation {
    condition = var.task_report_config == null || (
      contains(["ERRORS_ONLY", "SUCCESSES_AND_ERRORS"], var.task_report_config.report_level)
    )
    error_message = "resource_aws_datasync_task, task_report_config report_level must be ERRORS_ONLY or SUCCESSES_AND_ERRORS."
  }

  validation {
    condition = var.task_report_config == null || (
      can(regex("^arn:aws:iam::[0-9]{12}:role/", var.task_report_config.s3_destination.bucket_access_role_arn))
    )
    error_message = "resource_aws_datasync_task, task_report_config s3_destination bucket_access_role_arn must be a valid IAM role ARN."
  }

  validation {
    condition = var.task_report_config == null || (
      can(regex("^arn:aws:s3:::", var.task_report_config.s3_destination.s3_bucket_arn))
    )
    error_message = "resource_aws_datasync_task, task_report_config s3_destination s3_bucket_arn must be a valid S3 bucket ARN."
  }

  validation {
    condition = var.task_report_config == null || var.task_report_config.report_overrides == null || (
      var.task_report_config.report_overrides.deleted_override == null || contains(["ERRORS_ONLY", "SUCCESSES_AND_ERRORS"], var.task_report_config.report_overrides.deleted_override)
    )
    error_message = "resource_aws_datasync_task, task_report_config report_overrides deleted_override must be ERRORS_ONLY or SUCCESSES_AND_ERRORS."
  }

  validation {
    condition = var.task_report_config == null || var.task_report_config.report_overrides == null || (
      var.task_report_config.report_overrides.skipped_override == null || contains(["ERRORS_ONLY", "SUCCESSES_AND_ERRORS"], var.task_report_config.report_overrides.skipped_override)
    )
    error_message = "resource_aws_datasync_task, task_report_config report_overrides skipped_override must be ERRORS_ONLY or SUCCESSES_AND_ERRORS."
  }

  validation {
    condition = var.task_report_config == null || var.task_report_config.report_overrides == null || (
      var.task_report_config.report_overrides.transferred_override == null || contains(["ERRORS_ONLY", "SUCCESSES_AND_ERRORS"], var.task_report_config.report_overrides.transferred_override)
    )
    error_message = "resource_aws_datasync_task, task_report_config report_overrides transferred_override must be ERRORS_ONLY or SUCCESSES_AND_ERRORS."
  }

  validation {
    condition = var.task_report_config == null || var.task_report_config.report_overrides == null || (
      var.task_report_config.report_overrides.verified_override == null || contains(["ERRORS_ONLY", "SUCCESSES_AND_ERRORS"], var.task_report_config.report_overrides.verified_override)
    )
    error_message = "resource_aws_datasync_task, task_report_config report_overrides verified_override must be ERRORS_ONLY or SUCCESSES_AND_ERRORS."
  }
}

variable "tags" {
  description = "Key-value pairs of resource tags to assign to the DataSync Task"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration block for operation timeouts"
  type = object({
    create = optional(string, "5m")
  })
  default = {
    create = "5m"
  }
}