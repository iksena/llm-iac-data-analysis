variable "additional_encryption_context" {
  description = "Map of additional encryption context key-value pairs"
  type        = map(string)
  default     = null
}

variable "customer_managed_key" {
  description = "ARN of the customer managed KMS key used to encrypt sensitive information"
  type        = string
  default     = null

  validation {
    condition     = var.customer_managed_key == null || can(regex("^arn:aws[a-z0-9-]*:kms:[a-z0-9-]+:[0-9]{12}:key/[a-f0-9-]+$", var.customer_managed_key))
    error_message = "resource_aws_workspacesweb_session_logger, customer_managed_key must be a valid KMS key ARN"
  }
}

variable "display_name" {
  description = "Human-readable display name for the session logger resource"
  type        = string
  default     = null
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.region))
    error_message = "resource_aws_workspacesweb_session_logger, region must be a valid AWS region format"
  }
}

variable "tags" {
  description = "Map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "event_filter" {
  description = "Event filter that determines which events are logged"
  type = object({
    all     = optional(object({}))
    include = optional(list(string))
  })

  validation {
    condition = var.event_filter != null && (
      (var.event_filter.all != null && var.event_filter.include == null) ||
      (var.event_filter.all == null && var.event_filter.include != null)
    )
    error_message = "resource_aws_workspacesweb_session_logger, event_filter must specify exactly one of 'all' or 'include'"
  }

  validation {
    condition     = var.event_filter == null || var.event_filter.include == null || length(var.event_filter.include) > 0
    error_message = "resource_aws_workspacesweb_session_logger, event_filter.include must contain at least one event when specified"
  }
}

variable "log_configuration" {
  description = "Configuration block for specifying where logs are delivered"
  type = object({
    s3 = object({
      bucket           = string
      folder_structure = string
      log_file_format  = string
      bucket_owner     = optional(string)
      key_prefix       = optional(string)
    })
  })

  validation {
    condition     = contains(["FlatStructure", "DateBasedStructure"], var.log_configuration.s3.folder_structure)
    error_message = "resource_aws_workspacesweb_session_logger, log_configuration.s3.folder_structure must be either 'FlatStructure' or 'DateBasedStructure'"
  }

  validation {
    condition     = contains(["Json", "Parquet"], var.log_configuration.s3.log_file_format)
    error_message = "resource_aws_workspacesweb_session_logger, log_configuration.s3.log_file_format must be either 'Json' or 'Parquet'"
  }

  validation {
    condition     = can(regex("^[a-z0-9.-]+$", var.log_configuration.s3.bucket))
    error_message = "resource_aws_workspacesweb_session_logger, log_configuration.s3.bucket must be a valid S3 bucket name"
  }

  validation {
    condition     = var.log_configuration.s3.bucket_owner == null || can(regex("^[0-9]{12}$", var.log_configuration.s3.bucket_owner))
    error_message = "resource_aws_workspacesweb_session_logger, log_configuration.s3.bucket_owner must be a valid 12-digit AWS account ID"
  }
}