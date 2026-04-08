variable "cluster_identifier" {
  description = "Identifier of the source cluster"
  type        = string

  validation {
    condition     = length(var.cluster_identifier) > 0
    error_message = "resource_aws_redshift_logging, cluster_identifier must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "bucket_name" {
  description = "Name of an existing S3 bucket where the log files are to be stored. Required when log_destination_type is s3. Must be in the same region as the cluster and the cluster must have read bucket and put object permissions"
  type        = string
  default     = null

  validation {
    condition     = var.log_destination_type == "s3" ? var.bucket_name != null && length(var.bucket_name) > 0 : true
    error_message = "resource_aws_redshift_logging, bucket_name is required when log_destination_type is s3."
  }
}

variable "log_destination_type" {
  description = "Log destination type. Valid values are s3 and cloudwatch"
  type        = string
  default     = null

  validation {
    condition     = var.log_destination_type == null ? true : contains(["s3", "cloudwatch"], var.log_destination_type)
    error_message = "resource_aws_redshift_logging, log_destination_type must be either 's3' or 'cloudwatch'."
  }
}

variable "log_exports" {
  description = "Collection of exported log types. Required when log_destination_type is cloudwatch. Valid values are connectionlog, useractivitylog, and userlog"
  type        = list(string)
  default     = null

  validation {
    condition     = var.log_destination_type == "cloudwatch" ? var.log_exports != null && length(var.log_exports) > 0 : true
    error_message = "resource_aws_redshift_logging, log_exports is required when log_destination_type is cloudwatch."
  }

  validation {
    condition = var.log_exports == null ? true : alltrue([
      for log_type in var.log_exports : contains(["connectionlog", "useractivitylog", "userlog"], log_type)
    ])
    error_message = "resource_aws_redshift_logging, log_exports must contain only valid values: connectionlog, useractivitylog, userlog."
  }
}

variable "s3_key_prefix" {
  description = "Prefix applied to the log file names"
  type        = string
  default     = null
}