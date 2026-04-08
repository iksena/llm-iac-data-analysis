resource "aws_sagemaker_monitoring_schedule" "this" {
  name   = var.name
  region = var.region
  tags   = var.tags

  monitoring_schedule_config {
    monitoring_job_definition_name = var.monitoring_schedule_config.monitoring_job_definition_name
    monitoring_type                = var.monitoring_schedule_config.monitoring_type

    dynamic "schedule_config" {
      for_each = var.monitoring_schedule_config.schedule_config != null ? [var.monitoring_schedule_config.schedule_config] : []
      content {
        schedule_expression = schedule_config.value.schedule_expression
      }
    }
  }
}