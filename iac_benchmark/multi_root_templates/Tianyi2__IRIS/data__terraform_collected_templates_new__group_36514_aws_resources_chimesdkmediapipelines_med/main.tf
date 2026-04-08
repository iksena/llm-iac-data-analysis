resource "aws_chimesdkmediapipelines_media_insights_pipeline_configuration" "this" {
  name                     = var.name
  resource_access_role_arn = var.resource_access_role_arn
  region                   = var.region

  dynamic "elements" {
    for_each = var.elements
    content {
      type = elements.value.type

      dynamic "amazon_transcribe_call_analytics_processor_configuration" {
        for_each = elements.value.amazon_transcribe_call_analytics_processor_configuration != null ? [elements.value.amazon_transcribe_call_analytics_processor_configuration] : []
        content {
          call_analytics_stream_categories     = amazon_transcribe_call_analytics_processor_configuration.value.call_analytics_stream_categories
          content_identification_type          = amazon_transcribe_call_analytics_processor_configuration.value.content_identification_type
          content_redaction_type               = amazon_transcribe_call_analytics_processor_configuration.value.content_redaction_type
          enable_partial_results_stabilization = amazon_transcribe_call_analytics_processor_configuration.value.enable_partial_results_stabilization
          filter_partial_results               = amazon_transcribe_call_analytics_processor_configuration.value.filter_partial_results
          language_code                        = amazon_transcribe_call_analytics_processor_configuration.value.language_code
          language_model_name                  = amazon_transcribe_call_analytics_processor_configuration.value.language_model_name
          partial_results_stability            = amazon_transcribe_call_analytics_processor_configuration.value.partial_results_stability
          pii_entity_types                     = amazon_transcribe_call_analytics_processor_configuration.value.pii_entity_types
          vocabulary_filter_method             = amazon_transcribe_call_analytics_processor_configuration.value.vocabulary_filter_method
          vocabulary_filter_name               = amazon_transcribe_call_analytics_processor_configuration.value.vocabulary_filter_name
          vocabulary_name                      = amazon_transcribe_call_analytics_processor_configuration.value.vocabulary_name

          dynamic "post_call_analytics_settings" {
            for_each = amazon_transcribe_call_analytics_processor_configuration.value.post_call_analytics_settings != null ? [amazon_transcribe_call_analytics_processor_configuration.value.post_call_analytics_settings] : []
            content {
              content_redaction_output     = post_call_analytics_settings.value.content_redaction_output
              data_access_role_arn         = post_call_analytics_settings.value.data_access_role_arn
              output_encryption_kms_key_id = post_call_analytics_settings.value.output_encryption_kms_key_id
              output_location              = post_call_analytics_settings.value.output_location
            }
          }
        }
      }

      dynamic "amazon_transcribe_processor_configuration" {
        for_each = elements.value.amazon_transcribe_processor_configuration != null ? [elements.value.amazon_transcribe_processor_configuration] : []
        content {
          content_identification_type          = amazon_transcribe_processor_configuration.value.content_identification_type
          content_redaction_type               = amazon_transcribe_processor_configuration.value.content_redaction_type
          enable_partial_results_stabilization = amazon_transcribe_processor_configuration.value.enable_partial_results_stabilization
          filter_partial_results               = amazon_transcribe_processor_configuration.value.filter_partial_results
          language_code                        = amazon_transcribe_processor_configuration.value.language_code
          language_model_name                  = amazon_transcribe_processor_configuration.value.language_model_name
          partial_results_stability            = amazon_transcribe_processor_configuration.value.partial_results_stability
          pii_entity_types                     = amazon_transcribe_processor_configuration.value.pii_entity_types
          show_speaker_label                   = amazon_transcribe_processor_configuration.value.show_speaker_label
          vocabulary_filter_method             = amazon_transcribe_processor_configuration.value.vocabulary_filter_method
          vocabulary_filter_name               = amazon_transcribe_processor_configuration.value.vocabulary_filter_name
          vocabulary_name                      = amazon_transcribe_processor_configuration.value.vocabulary_name
        }
      }

      dynamic "kinesis_data_stream_sink_configuration" {
        for_each = elements.value.kinesis_data_stream_sink_configuration != null ? [elements.value.kinesis_data_stream_sink_configuration] : []
        content {
          insights_target = kinesis_data_stream_sink_configuration.value.insights_target
        }
      }

      dynamic "lambda_function_sink_configuration" {
        for_each = elements.value.lambda_function_sink_configuration != null ? [elements.value.lambda_function_sink_configuration] : []
        content {
          insights_target = lambda_function_sink_configuration.value.insights_target
        }
      }

      dynamic "sns_topic_sink_configuration" {
        for_each = elements.value.sns_topic_sink_configuration != null ? [elements.value.sns_topic_sink_configuration] : []
        content {
          insights_target = sns_topic_sink_configuration.value.insights_target
        }
      }

      dynamic "sqs_queue_sink_configuration" {
        for_each = elements.value.sqs_queue_sink_configuration != null ? [elements.value.sqs_queue_sink_configuration] : []
        content {
          insights_target = sqs_queue_sink_configuration.value.insights_target
        }
      }

      dynamic "s3_recording_sink_configuration" {
        for_each = elements.value.s3_recording_sink_configuration != null ? [elements.value.s3_recording_sink_configuration] : []
        content {
          destination = s3_recording_sink_configuration.value.destination
        }
      }

      dynamic "voice_analytics_processor_configuration" {
        for_each = elements.value.voice_analytics_processor_configuration != null ? [elements.value.voice_analytics_processor_configuration] : []
        content {
          speaker_search_status      = voice_analytics_processor_configuration.value.speaker_search_status
          voice_tone_analysis_status = voice_analytics_processor_configuration.value.voice_tone_analysis_status
        }
      }
    }
  }

  dynamic "real_time_alert_configuration" {
    for_each = var.real_time_alert_configuration != null ? [var.real_time_alert_configuration] : []
    content {
      disabled = real_time_alert_configuration.value.disabled

      dynamic "rules" {
        for_each = real_time_alert_configuration.value.rules
        content {
          type = rules.value.type

          dynamic "issue_detection_configuration" {
            for_each = rules.value.issue_detection_configuration != null ? [rules.value.issue_detection_configuration] : []
            content {
              rule_name = issue_detection_configuration.value.rule_name
            }
          }

          dynamic "keyword_match_configuration" {
            for_each = rules.value.keyword_match_configuration != null ? [rules.value.keyword_match_configuration] : []
            content {
              keywords  = keyword_match_configuration.value.keywords
              negate    = keyword_match_configuration.value.negate
              rule_name = keyword_match_configuration.value.rule_name
            }
          }

          dynamic "sentiment_configuration" {
            for_each = rules.value.sentiment_configuration != null ? [rules.value.sentiment_configuration] : []
            content {
              rule_name      = sentiment_configuration.value.rule_name
              sentiment_type = sentiment_configuration.value.sentiment_type
              time_period    = sentiment_configuration.value.time_period
            }
          }
        }
      }
    }
  }

  tags = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}