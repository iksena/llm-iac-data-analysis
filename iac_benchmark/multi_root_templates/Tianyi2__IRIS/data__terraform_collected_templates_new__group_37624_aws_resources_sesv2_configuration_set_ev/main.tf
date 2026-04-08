resource "aws_sesv2_configuration_set_event_destination" "this" {
  region                 = var.region
  configuration_set_name = var.configuration_set_name
  event_destination_name = var.event_destination_name

  event_destination {
    matching_event_types = var.event_destination.matching_event_types
    enabled              = var.event_destination.enabled

    dynamic "cloud_watch_destination" {
      for_each = var.event_destination.cloud_watch_destination != null ? [var.event_destination.cloud_watch_destination] : []
      content {
        dynamic "dimension_configuration" {
          for_each = cloud_watch_destination.value.dimension_configuration
          content {
            default_dimension_value = dimension_configuration.value.default_dimension_value
            dimension_name          = dimension_configuration.value.dimension_name
            dimension_value_source  = dimension_configuration.value.dimension_value_source
          }
        }
      }
    }

    dynamic "event_bridge_destination" {
      for_each = var.event_destination.event_bridge_destination != null ? [var.event_destination.event_bridge_destination] : []
      content {
        event_bus_arn = event_bridge_destination.value.event_bus_arn
      }
    }

    dynamic "kinesis_firehose_destination" {
      for_each = var.event_destination.kinesis_firehose_destination != null ? [var.event_destination.kinesis_firehose_destination] : []
      content {
        delivery_stream_arn = kinesis_firehose_destination.value.delivery_stream_arn
        iam_role_arn        = kinesis_firehose_destination.value.iam_role_arn
      }
    }

    dynamic "pinpoint_destination" {
      for_each = var.event_destination.pinpoint_destination != null ? [var.event_destination.pinpoint_destination] : []
      content {
        application_arn = pinpoint_destination.value.application_arn
      }
    }

    dynamic "sns_destination" {
      for_each = var.event_destination.sns_destination != null ? [var.event_destination.sns_destination] : []
      content {
        topic_arn = sns_destination.value.topic_arn
      }
    }
  }
}