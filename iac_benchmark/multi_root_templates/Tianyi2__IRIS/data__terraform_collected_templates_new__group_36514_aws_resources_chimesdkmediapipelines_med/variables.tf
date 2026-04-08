variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "name" {
  description = "Configuration name"
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "resource_access_role_arn" {
  description = "ARN of IAM Role used by service to invoke processors and sinks specified by configuration elements"
  type        = string

  validation {
    condition     = can(regex("^arn:aws:iam::[0-9]{12}:role/[a-zA-Z0-9+=,.@_-]+$", var.resource_access_role_arn))
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, resource_access_role_arn must be a valid IAM role ARN."
  }
}

variable "elements" {
  description = "Collection of processors and sinks to transform media and deliver data"
  type = list(object({
    type = string
    amazon_transcribe_call_analytics_processor_configuration = optional(object({
      call_analytics_stream_categories     = optional(list(string))
      content_identification_type          = optional(string)
      content_redaction_type               = optional(string)
      enable_partial_results_stabilization = optional(bool)
      filter_partial_results               = optional(bool)
      language_code                        = string
      language_model_name                  = optional(string)
      partial_results_stability            = optional(string)
      pii_entity_types                     = optional(string)
      vocabulary_filter_method             = optional(string)
      vocabulary_filter_name               = optional(string)
      vocabulary_name                      = optional(string)
      post_call_analytics_settings = optional(object({
        content_redaction_output     = optional(string)
        data_access_role_arn         = string
        output_encryption_kms_key_id = optional(string)
        output_location              = string
      }))
    }))
    amazon_transcribe_processor_configuration = optional(object({
      content_identification_type          = optional(string)
      content_redaction_type               = optional(string)
      enable_partial_results_stabilization = optional(bool)
      filter_partial_results               = optional(bool)
      language_code                        = string
      language_model_name                  = optional(string)
      partial_results_stability            = optional(string)
      pii_entity_types                     = optional(string)
      show_speaker_label                   = optional(bool)
      vocabulary_filter_method             = optional(string)
      vocabulary_filter_name               = optional(string)
      vocabulary_name                      = optional(string)
    }))
    kinesis_data_stream_sink_configuration = optional(object({
      insights_target = string
    }))
    lambda_function_sink_configuration = optional(object({
      insights_target = string
    }))
    sns_topic_sink_configuration = optional(object({
      insights_target = string
    }))
    sqs_queue_sink_configuration = optional(object({
      insights_target = string
    }))
    s3_recording_sink_configuration = optional(object({
      destination = string
    }))
    voice_analytics_processor_configuration = optional(object({
      speaker_search_status      = string
      voice_tone_analysis_status = string
    }))
  }))

  validation {
    condition     = length(var.elements) > 0
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements must contain at least one element."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      contains([
        "AmazonTranscribeCallAnalyticsProcessor",
        "AmazonTranscribeProcessor",
        "KinesisDataStreamSink",
        "LambdaFunctionSink",
        "SnsTopicSink",
        "SqsQueueSink",
        "S3RecordingSink",
        "VoiceAnalyticsProcessor"
      ], element.type)
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements type must be one of: AmazonTranscribeCallAnalyticsProcessor, AmazonTranscribeProcessor, KinesisDataStreamSink, LambdaFunctionSink, SnsTopicSink, SqsQueueSink, S3RecordingSink, VoiceAnalyticsProcessor."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_call_analytics_processor_configuration != null ?
      contains(["PII"], coalesce(element.amazon_transcribe_call_analytics_processor_configuration.content_identification_type, "")) || element.amazon_transcribe_call_analytics_processor_configuration.content_identification_type == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_call_analytics_processor_configuration content_identification_type must be 'PII' when specified."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_call_analytics_processor_configuration != null ?
      contains(["PII"], coalesce(element.amazon_transcribe_call_analytics_processor_configuration.content_redaction_type, "")) || element.amazon_transcribe_call_analytics_processor_configuration.content_redaction_type == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_call_analytics_processor_configuration content_redaction_type must be 'PII' when specified."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_call_analytics_processor_configuration != null ?
      contains(["low", "medium", "high"], coalesce(element.amazon_transcribe_call_analytics_processor_configuration.partial_results_stability, "")) || element.amazon_transcribe_call_analytics_processor_configuration.partial_results_stability == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_call_analytics_processor_configuration partial_results_stability must be one of: low, medium, high."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_call_analytics_processor_configuration != null ?
      contains(["mask", "remove", "tag"], coalesce(element.amazon_transcribe_call_analytics_processor_configuration.vocabulary_filter_method, "")) || element.amazon_transcribe_call_analytics_processor_configuration.vocabulary_filter_method == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_call_analytics_processor_configuration vocabulary_filter_method must be one of: mask, remove, tag."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_call_analytics_processor_configuration != null && element.amazon_transcribe_call_analytics_processor_configuration.post_call_analytics_settings != null ?
      contains(["redacted", "redacted_and_unredacted"], coalesce(element.amazon_transcribe_call_analytics_processor_configuration.post_call_analytics_settings.content_redaction_output, "")) || element.amazon_transcribe_call_analytics_processor_configuration.post_call_analytics_settings.content_redaction_output == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_call_analytics_processor_configuration post_call_analytics_settings content_redaction_output must be one of: redacted, redacted_and_unredacted."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_processor_configuration != null ?
      contains(["PII"], coalesce(element.amazon_transcribe_processor_configuration.content_identification_type, "")) || element.amazon_transcribe_processor_configuration.content_identification_type == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_processor_configuration content_identification_type must be 'PII' when specified."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_processor_configuration != null ?
      contains(["PII"], coalesce(element.amazon_transcribe_processor_configuration.content_redaction_type, "")) || element.amazon_transcribe_processor_configuration.content_redaction_type == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_processor_configuration content_redaction_type must be 'PII' when specified."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_processor_configuration != null ?
      contains(["low", "medium", "high"], coalesce(element.amazon_transcribe_processor_configuration.partial_results_stability, "")) || element.amazon_transcribe_processor_configuration.partial_results_stability == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_processor_configuration partial_results_stability must be one of: low, medium, high."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.amazon_transcribe_processor_configuration != null ?
      contains(["mask", "remove", "tag"], coalesce(element.amazon_transcribe_processor_configuration.vocabulary_filter_method, "")) || element.amazon_transcribe_processor_configuration.vocabulary_filter_method == null : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements amazon_transcribe_processor_configuration vocabulary_filter_method must be one of: mask, remove, tag."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.kinesis_data_stream_sink_configuration != null ?
      can(regex("^arn:aws:kinesis:[a-z0-9-]+:[0-9]{12}:stream/[a-zA-Z0-9._-]+$", element.kinesis_data_stream_sink_configuration.insights_target)) : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements kinesis_data_stream_sink_configuration insights_target must be a valid Kinesis stream ARN."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.lambda_function_sink_configuration != null ?
      can(regex("^arn:aws:lambda:[a-z0-9-]+:[0-9]{12}:function:[a-zA-Z0-9._-]+$", element.lambda_function_sink_configuration.insights_target)) : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements lambda_function_sink_configuration insights_target must be a valid Lambda function ARN."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.sns_topic_sink_configuration != null ?
      can(regex("^arn:aws:sns:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9._-]+$", element.sns_topic_sink_configuration.insights_target)) : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements sns_topic_sink_configuration insights_target must be a valid SNS topic ARN."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.sqs_queue_sink_configuration != null ?
      can(regex("^arn:aws:sqs:[a-z0-9-]+:[0-9]{12}:[a-zA-Z0-9._-]+$", element.sqs_queue_sink_configuration.insights_target)) : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements sqs_queue_sink_configuration insights_target must be a valid SQS queue ARN."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.s3_recording_sink_configuration != null ?
      can(regex("^arn:aws:s3:::[a-zA-Z0-9._-]+$", element.s3_recording_sink_configuration.destination)) : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements s3_recording_sink_configuration destination must be a valid S3 bucket ARN."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.voice_analytics_processor_configuration != null ?
      contains(["Enabled", "Disabled"], element.voice_analytics_processor_configuration.speaker_search_status) : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements voice_analytics_processor_configuration speaker_search_status must be either 'Enabled' or 'Disabled'."
  }

  validation {
    condition = alltrue([
      for element in var.elements :
      element.voice_analytics_processor_configuration != null ?
      contains(["Enabled", "Disabled"], element.voice_analytics_processor_configuration.voice_tone_analysis_status) : true
    ])
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, elements voice_analytics_processor_configuration voice_tone_analysis_status must be either 'Enabled' or 'Disabled'."
  }
}

variable "real_time_alert_configuration" {
  description = "Configuration for real-time alert rules to send EventBridge notifications when certain conditions are met"
  type = object({
    disabled = optional(bool)
    rules = list(object({
      type = string
      issue_detection_configuration = optional(object({
        rule_name = string
      }))
      keyword_match_configuration = optional(object({
        keywords  = list(string)
        negate    = optional(bool)
        rule_name = string
      }))
      sentiment_configuration = optional(object({
        rule_name      = string
        sentiment_type = string
        time_period    = optional(number)
      }))
    }))
  })
  default = null

  validation {
    condition     = var.real_time_alert_configuration != null ? length(var.real_time_alert_configuration.rules) > 0 : true
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, real_time_alert_configuration rules must contain at least one rule when specified."
  }

  validation {
    condition = var.real_time_alert_configuration != null ? alltrue([
      for rule in var.real_time_alert_configuration.rules :
      contains(["IssueDetection", "KeywordMatch", "Sentiment"], rule.type)
    ]) : true
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, real_time_alert_configuration rules type must be one of: IssueDetection, KeywordMatch, Sentiment."
  }

  validation {
    condition = var.real_time_alert_configuration != null ? alltrue([
      for rule in var.real_time_alert_configuration.rules :
      rule.keyword_match_configuration != null ? length(rule.keyword_match_configuration.keywords) > 0 : true
    ]) : true
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, real_time_alert_configuration rules keyword_match_configuration keywords must contain at least one keyword when specified."
  }

  validation {
    condition = var.real_time_alert_configuration != null ? alltrue([
      for rule in var.real_time_alert_configuration.rules :
      rule.sentiment_configuration != null ? contains(["POSITIVE", "NEGATIVE", "NEUTRAL"], rule.sentiment_configuration.sentiment_type) : true
    ]) : true
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, real_time_alert_configuration rules sentiment_configuration sentiment_type must be one of: POSITIVE, NEGATIVE, NEUTRAL."
  }

  validation {
    condition = var.real_time_alert_configuration != null ? alltrue([
      for rule in var.real_time_alert_configuration.rules :
      rule.sentiment_configuration != null && rule.sentiment_configuration.time_period != null ? rule.sentiment_configuration.time_period >= 60 && rule.sentiment_configuration.time_period <= 14400 : true
    ]) : true
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, real_time_alert_configuration rules sentiment_configuration time_period must be between 60 and 14400 seconds when specified."
  }
}

variable "tags" {
  description = "Key-value map of tags for the resource"
  type        = map(string)
  default     = {}
}

variable "timeouts" {
  description = "Configuration options for resource timeouts"
  type = object({
    create = optional(string, "3m")
    update = optional(string, "3m")
    delete = optional(string, "30s")
  })
  default = {}

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.create))
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, timeouts create must be a valid duration (e.g., 3m, 30s, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.update))
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, timeouts update must be a valid duration (e.g., 3m, 30s, 1h)."
  }

  validation {
    condition     = can(regex("^[0-9]+[smh]$", var.timeouts.delete))
    error_message = "resource_aws_chimesdkmediapipelines_media_insights_pipeline_configuration, timeouts delete must be a valid duration (e.g., 3m, 30s, 1h)."
  }
}