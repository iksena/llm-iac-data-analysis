variable "association_id" {
  description = "The existing association identifier that uniquely identifies the resource type and storage config for the given instance ID"
  type        = string

  validation {
    condition     = length(var.association_id) > 0
    error_message = "data_aws_connect_instance_storage_config, association_id must be a non-empty string."
  }
}

variable "instance_id" {
  description = "Reference to the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "data_aws_connect_instance_storage_config, instance_id must be a non-empty string."
  }
}

variable "resource_type" {
  description = "A valid resource type"
  type        = string

  validation {
    condition = contains([
      "AGENT_EVENTS",
      "ATTACHMENTS",
      "CALL_RECORDINGS",
      "CHAT_TRANSCRIPTS",
      "CONTACT_EVALUATIONS",
      "CONTACT_TRACE_RECORDS",
      "MEDIA_STREAMS",
      "REAL_TIME_CONTACT_ANALYSIS_SEGMENTS",
      "SCHEDULED_REPORTS",
      "SCREEN_RECORDINGS"
    ], var.resource_type)
    error_message = "data_aws_connect_instance_storage_config, resource_type must be one of: AGENT_EVENTS, ATTACHMENTS, CALL_RECORDINGS, CHAT_TRANSCRIPTS, CONTACT_EVALUATIONS, CONTACT_TRACE_RECORDS, MEDIA_STREAMS, REAL_TIME_CONTACT_ANALYSIS_SEGMENTS, SCHEDULED_REPORTS, SCREEN_RECORDINGS."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration"
  type        = string
  default     = null
}