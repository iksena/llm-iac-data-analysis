variable "destination_configuration_s3_bucket_name" {
  description = "S3 bucket name where recorded videos will be stored"
  type        = string

  validation {
    condition     = length(var.destination_configuration_s3_bucket_name) > 0
    error_message = "resource_aws_ivs_recording_configuration, destination_configuration_s3_bucket_name must not be empty."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}

variable "name" {
  description = "Recording Configuration name"
  type        = string
  default     = null
}

variable "recording_reconnect_window_seconds" {
  description = "If a broadcast disconnects and then reconnects within the specified interval, the multiple streams will be considered a single broadcast and merged together"
  type        = number
  default     = null

  validation {
    condition     = var.recording_reconnect_window_seconds == null || var.recording_reconnect_window_seconds >= 0
    error_message = "resource_aws_ivs_recording_configuration, recording_reconnect_window_seconds must be a non-negative number."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource"
  type        = map(string)
  default     = {}
}

variable "thumbnail_configuration" {
  description = "Object containing information to enable/disable the recording of thumbnails for a live session and modify the interval at which thumbnails are generated for the live session"
  type = object({
    recording_mode          = optional(string, "DISABLED")
    target_interval_seconds = optional(number)
  })
  default = null

  validation {
    condition     = var.thumbnail_configuration == null || contains(["DISABLED", "INTERVAL"], var.thumbnail_configuration.recording_mode)
    error_message = "resource_aws_ivs_recording_configuration, thumbnail_configuration.recording_mode must be either 'DISABLED' or 'INTERVAL'."
  }

  validation {
    condition     = var.thumbnail_configuration == null || var.thumbnail_configuration.recording_mode != "INTERVAL" || var.thumbnail_configuration.target_interval_seconds != null
    error_message = "resource_aws_ivs_recording_configuration, thumbnail_configuration.target_interval_seconds is required when recording_mode is 'INTERVAL'."
  }

  validation {
    condition     = var.thumbnail_configuration == null || var.thumbnail_configuration.target_interval_seconds == null || var.thumbnail_configuration.target_interval_seconds > 0
    error_message = "resource_aws_ivs_recording_configuration, thumbnail_configuration.target_interval_seconds must be a positive number."
  }
}

variable "timeouts" {
  description = "Configuration options for timeouts"
  type = object({
    create = optional(string, "10m")
    delete = optional(string, "10m")
  })
  default = {
    create = "10m"
    delete = "10m"
  }
}