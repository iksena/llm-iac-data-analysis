resource "aws_lambda_event_source_mapping" "this" {
  function_name = var.function_name
  dynamic "amazon_managed_kafka_event_source_config" {
    for_each = var.amazon_managed_kafka_event_source_config != null ? [var.amazon_managed_kafka_event_source_config] : []
    content {
      consumer_group_id = amazon_managed_kafka_event_source_config.value.consumer_group_id
    }
  }
  batch_size                     = var.batch_size
  bisect_batch_on_function_error = var.bisect_batch_on_function_error
  dynamic "destination_config" {
    for_each = var.destination_config != null ? [var.destination_config] : []
    content {
      on_failure {
        destination_arn = destination_config.value.on_failure.destination_arn
      }
    }
  }
  dynamic "document_db_event_source_config" {
    for_each = var.document_db_event_source_config != null ? [var.document_db_event_source_config] : []
    content {
      database_name   = document_db_event_source_config.value.database_name
      collection_name = document_db_event_source_config.value.collection_name
      full_document   = document_db_event_source_config.value.full_document
    }
  }
  enabled          = var.enabled
  event_source_arn = var.event_source_arn
  dynamic "filter_criteria" {
    for_each = var.filter_criteria != null ? [var.filter_criteria] : []
    content {
      filter {
        pattern = filter_criteria.value.filter.pattern
      }
    }
  }
  function_response_types            = var.function_response_types
  kms_key_arn                        = var.kms_key_arn
  maximum_batching_window_in_seconds = var.maximum_batching_window_in_seconds
  maximum_record_age_in_seconds      = var.maximum_record_age_in_seconds
  maximum_retry_attempts             = var.maximum_retry_attempts
  dynamic "metrics_config" {
    for_each = var.metrics_config != null ? [var.metrics_config] : []
    content {
      metrics = metrics_config.value.metrics
    }
  }
  parallelization_factor = var.parallelization_factor
  dynamic "provisioned_poller_config" {
    for_each = var.provisioned_poller_config != null ? [var.provisioned_poller_config] : []
    content {
      maximum_pollers = provisioned_poller_config.value.maximum_pollers
      minimum_pollers = provisioned_poller_config.value.minimum_pollers
    }
  }
  queues = var.queues
  region = var.region
  dynamic "scaling_config" {
    for_each = var.scaling_config != null ? [var.scaling_config] : []
    content {
      maximum_concurrency = scaling_config.value.maximum_concurrency
    }
  }
  dynamic "self_managed_event_source" {
    for_each = var.self_managed_event_source != null ? [var.self_managed_event_source] : []
    content {
      endpoints = self_managed_event_source.value.endpoints
    }
  }
  dynamic "self_managed_kafka_event_source_config" {
    for_each = var.self_managed_kafka_event_source_config != null ? [var.self_managed_kafka_event_source_config] : []
    content {
      consumer_group_id = self_managed_kafka_event_source_config.value.consumer_group_id
    }
  }
  dynamic "source_access_configuration" {
    for_each = var.source_access_configuration != null ? [var.source_access_configuration] : []
    content {
      type = source_access_configuration.value.type
      uri  = source_access_configuration.value.uri
    }
  }
  starting_position           = var.starting_position
  starting_position_timestamp = var.starting_position_timestamp
  tags                        = var.tags
  topics                      = var.topics
  tumbling_window_in_seconds  = var.tumbling_window_in_seconds
}