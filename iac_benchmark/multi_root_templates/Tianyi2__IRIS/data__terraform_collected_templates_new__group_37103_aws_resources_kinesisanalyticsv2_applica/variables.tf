variable "application_name" {
  description = "The name of an existing Kinesis Analytics v2 Application. Note that the application must be running for a snapshot to be created."
  type        = string

  validation {
    condition     = length(var.application_name) > 0
    error_message = "resource_aws_kinesisanalyticsv2_application_snapshot, application_name must not be empty."
  }
}

variable "snapshot_name" {
  description = "The name of the application snapshot."
  type        = string

  validation {
    condition     = length(var.snapshot_name) > 0
    error_message = "resource_aws_kinesisanalyticsv2_application_snapshot, snapshot_name must not be empty."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts."
  type = object({
    create = optional(string)
    delete = optional(string)
  })
  default = null
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}