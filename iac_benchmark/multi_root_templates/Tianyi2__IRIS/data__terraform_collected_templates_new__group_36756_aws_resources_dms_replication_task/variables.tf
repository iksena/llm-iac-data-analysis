variable "region" {
  type        = string
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  default     = null
}

variable "cdc_start_position" {
  type        = string
  description = "Indicates when you want a change data capture (CDC) operation to start. The value can be a RFC3339 formatted date, a checkpoint, or a LSN/SCN format depending on the source engine. Conflicts with cdc_start_time."
  default     = null
}

variable "cdc_start_time" {
  type        = string
  description = "RFC3339 formatted date string or UNIX timestamp for the start of the Change Data Capture (CDC) operation. Conflicts with cdc_start_position."
  default     = null
}

variable "migration_type" {
  type        = string
  description = "Migration type. Can be one of full-load | cdc | full-load-and-cdc."

  validation {
    condition     = contains(["full-load", "cdc", "full-load-and-cdc"], var.migration_type)
    error_message = "resource_aws_dms_replication_task, migration_type must be one of: full-load, cdc, full-load-and-cdc."
  }
}

variable "replication_instance_arn" {
  type        = string
  description = "ARN of the replication instance."
}

variable "replication_task_id" {
  type        = string
  description = "Replication task identifier which must contain from 1 to 255 alphanumeric characters or hyphens, first character must be a letter, cannot end with a hyphen, and cannot contain two consecutive hyphens."

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.replication_task_id)) && length(var.replication_task_id) >= 1 && length(var.replication_task_id) <= 255 && !can(regex("--", var.replication_task_id))
    error_message = "resource_aws_dms_replication_task, replication_task_id must contain from 1 to 255 alphanumeric characters or hyphens, first character must be a letter, cannot end with a hyphen, and cannot contain two consecutive hyphens."
  }
}

variable "replication_task_settings" {
  type        = string
  description = "Escaped JSON string that contains the task settings. Note that Logging.CloudWatchLogGroup and Logging.CloudWatchLogStream are read only and should not be defined."
  default     = null
}

variable "resource_identifier" {
  type        = string
  description = "A friendly name for the resource identifier at the end of the EndpointArn response parameter that is returned in the created Endpoint object."
  default     = null
}

variable "source_endpoint_arn" {
  type        = string
  description = "ARN that uniquely identifies the source endpoint."
}

variable "start_replication_task" {
  type        = bool
  description = "Whether to run or stop the replication task."
  default     = null
}

variable "table_mappings" {
  type        = string
  description = "Escaped JSON string that contains the table mappings."
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to assign to the resource."
  default     = {}
}

variable "target_endpoint_arn" {
  type        = string
  description = "ARN that uniquely identifies the target endpoint."
}