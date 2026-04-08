check "filter_conflict" {
  assert {
    condition     = !(var.exclude_filter != null && var.include_filter != null)
    error_message = "resource_aws_cloudwatch_metric_stream, exclude_filter conflicts with include_filter. Only one can be specified."
  }
}

check "name_conflict" {
  assert {
    condition     = !(var.name != null && var.name_prefix != null)
    error_message = "resource_aws_cloudwatch_metric_stream, name conflicts with name_prefix. Only one can be specified."
  }
}

resource "aws_cloudwatch_metric_stream" "this" {
  firehose_arn  = var.firehose_arn
  role_arn      = var.role_arn
  output_format = var.output_format

  region                          = var.region
  name                            = var.name
  name_prefix                     = var.name_prefix
  include_linked_accounts_metrics = var.include_linked_accounts_metrics
  tags                            = var.tags

  dynamic "exclude_filter" {
    for_each = var.exclude_filter != null ? var.exclude_filter : []
    content {
      namespace    = exclude_filter.value.namespace
      metric_names = exclude_filter.value.metric_names
    }
  }

  dynamic "include_filter" {
    for_each = var.include_filter != null ? var.include_filter : []
    content {
      namespace    = include_filter.value.namespace
      metric_names = include_filter.value.metric_names
    }
  }

  dynamic "statistics_configuration" {
    for_each = var.statistics_configuration != null ? var.statistics_configuration : []
    content {
      additional_statistics = statistics_configuration.value.additional_statistics

      dynamic "include_metric" {
        for_each = statistics_configuration.value.include_metric != null ? statistics_configuration.value.include_metric : []
        content {
          metric_name = include_metric.value.metric_name
          namespace   = include_metric.value.namespace
        }
      }
    }
  }
}