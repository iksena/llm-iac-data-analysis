resource "aws_cloudwatch_log_metric_filter" "this" {
  region                    = var.region
  name                      = var.name
  pattern                   = var.pattern
  log_group_name            = var.log_group_name
  apply_on_transformed_logs = var.apply_on_transformed_logs

  metric_transformation {
    name          = var.metric_transformation.name
    namespace     = var.metric_transformation.namespace
    value         = var.metric_transformation.value
    default_value = var.metric_transformation.default_value
    dimensions    = var.metric_transformation.dimensions
    unit          = var.metric_transformation.unit
  }
}