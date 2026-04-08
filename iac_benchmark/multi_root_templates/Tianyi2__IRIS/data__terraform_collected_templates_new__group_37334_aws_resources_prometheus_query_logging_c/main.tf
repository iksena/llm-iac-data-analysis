resource "aws_prometheus_query_logging_configuration" "this" {
  workspace_id = var.workspace_id

  destination {
    cloudwatch_logs {
      log_group_arn = var.destination.cloudwatch_logs.log_group_arn
    }

    filters {
      qsp_threshold = var.destination.filters.qsp_threshold
    }
  }

  region = var.region

  timeouts {
    create = "5m"
    update = "5m"
    delete = "5m"
  }
}