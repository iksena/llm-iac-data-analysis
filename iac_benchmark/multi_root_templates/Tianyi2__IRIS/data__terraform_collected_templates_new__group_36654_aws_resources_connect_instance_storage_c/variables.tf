variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "instance_id" {
  description = "Specifies the identifier of the hosting Amazon Connect Instance"
  type        = string

  validation {
    condition     = length(var.instance_id) > 0
    error_message = "resource_aws_connect_instance_storage_config, instance_id cannot be empty"
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
      "EMAIL_MESSAGES",
      "MEDIA_STREAMS",
      "REAL_TIME_CONTACT_ANALYSIS_CHAT_SEGMENTS",
      "REAL_TIME_CONTACT_ANALYSIS_SEGMENTS",
      "REAL_TIME_CONTACT_ANALYSIS_VOICE_SEGMENTS",
      "SCHEDULED_REPORTS",
      "SCREEN_RECORDINGS"
    ], var.resource_type)
    error_message = "resource_aws_connect_instance_storage_config, resource_type must be one of: AGENT_EVENTS, ATTACHMENTS, CALL_RECORDINGS, CHAT_TRANSCRIPTS, CONTACT_EVALUATIONS, CONTACT_TRACE_RECORDS, EMAIL_MESSAGES, MEDIA_STREAMS, REAL_TIME_CONTACT_ANALYSIS_CHAT_SEGMENTS, REAL_TIME_CONTACT_ANALYSIS_SEGMENTS, REAL_TIME_CONTACT_ANALYSIS_VOICE_SEGMENTS, SCHEDULED_REPORTS, SCREEN_RECORDINGS"
  }
}

variable "storage_config" {
  description = "Specifies the storage configuration options for the Connect Instance"
  type = object({
    storage_type = string
    kinesis_firehose_config = optional(object({
      firehose_arn = string
    }))
    kinesis_stream_config = optional(object({
      stream_arn = string
    }))
    kinesis_video_stream_config = optional(object({
      prefix                 = string
      retention_period_hours = number
      encryption_config = object({
        encryption_type = string
        key_id          = string
      })
    }))
    s3_config = optional(object({
      bucket_name   = string
      bucket_prefix = string
      encryption_config = optional(object({
        encryption_type = string
        key_id          = string
      }))
    }))
  })

  validation {
    condition     = contains(["S3", "KINESIS_VIDEO_STREAM", "KINESIS_STREAM", "KINESIS_FIREHOSE"], var.storage_config.storage_type)
    error_message = "resource_aws_connect_instance_storage_config, storage_type must be one of: S3, KINESIS_VIDEO_STREAM, KINESIS_STREAM, KINESIS_FIREHOSE"
  }

  validation {
    condition = (
      var.storage_config.storage_type == "KINESIS_FIREHOSE" && var.storage_config.kinesis_firehose_config != null ||
      var.storage_config.storage_type == "KINESIS_STREAM" && var.storage_config.kinesis_stream_config != null ||
      var.storage_config.storage_type == "KINESIS_VIDEO_STREAM" && var.storage_config.kinesis_video_stream_config != null ||
      var.storage_config.storage_type == "S3" && var.storage_config.s3_config != null
    )
    error_message = "resource_aws_connect_instance_storage_config, corresponding config block must be provided for the specified storage_type"
  }

  validation {
    condition = (
      var.storage_config.kinesis_firehose_config == null ||
      length(var.storage_config.kinesis_firehose_config.firehose_arn) > 0
    )
    error_message = "resource_aws_connect_instance_storage_config, firehose_arn cannot be empty when kinesis_firehose_config is specified"
  }

  validation {
    condition = (
      var.storage_config.kinesis_stream_config == null ||
      length(var.storage_config.kinesis_stream_config.stream_arn) > 0
    )
    error_message = "resource_aws_connect_instance_storage_config, stream_arn cannot be empty when kinesis_stream_config is specified"
  }

  validation {
    condition = (
      var.storage_config.kinesis_video_stream_config == null ||
      (
        length(var.storage_config.kinesis_video_stream_config.prefix) >= 1 &&
        length(var.storage_config.kinesis_video_stream_config.prefix) <= 128
      )
    )
    error_message = "resource_aws_connect_instance_storage_config, prefix must be between 1 and 128 characters when kinesis_video_stream_config is specified"
  }

  validation {
    condition = (
      var.storage_config.kinesis_video_stream_config == null ||
      (
        var.storage_config.kinesis_video_stream_config.retention_period_hours >= 0 &&
        var.storage_config.kinesis_video_stream_config.retention_period_hours <= 87600
      )
    )
    error_message = "resource_aws_connect_instance_storage_config, retention_period_hours must be between 0 and 87600 when kinesis_video_stream_config is specified"
  }

  validation {
    condition = (
      var.storage_config.kinesis_video_stream_config == null ||
      var.storage_config.kinesis_video_stream_config.encryption_config.encryption_type == "KMS"
    )
    error_message = "resource_aws_connect_instance_storage_config, encryption_type must be KMS when encryption_config is specified"
  }

  validation {
    condition = (
      var.storage_config.kinesis_video_stream_config == null ||
      length(var.storage_config.kinesis_video_stream_config.encryption_config.key_id) > 0
    )
    error_message = "resource_aws_connect_instance_storage_config, key_id cannot be empty when encryption_config is specified"
  }

  validation {
    condition = (
      var.storage_config.s3_config == null ||
      length(var.storage_config.s3_config.bucket_name) > 0
    )
    error_message = "resource_aws_connect_instance_storage_config, bucket_name cannot be empty when s3_config is specified"
  }

  validation {
    condition = (
      var.storage_config.s3_config == null ||
      length(var.storage_config.s3_config.bucket_prefix) > 0
    )
    error_message = "resource_aws_connect_instance_storage_config, bucket_prefix cannot be empty when s3_config is specified"
  }

  validation {
    condition = (
      var.storage_config.s3_config == null ||
      var.storage_config.s3_config.encryption_config == null ||
      var.storage_config.s3_config.encryption_config.encryption_type == "KMS"
    )
    error_message = "resource_aws_connect_instance_storage_config, encryption_type must be KMS when s3_config encryption_config is specified"
  }

  validation {
    condition = (
      var.storage_config.s3_config == null ||
      var.storage_config.s3_config.encryption_config == null ||
      length(var.storage_config.s3_config.encryption_config.key_id) > 0
    )
    error_message = "resource_aws_connect_instance_storage_config, key_id cannot be empty when s3_config encryption_config is specified"
  }
}