resource "aws_appautoscaling_scheduled_action" "this" {
  name               = var.name
  service_namespace  = var.service_namespace
  resource_id        = var.resource_id
  scalable_dimension = var.scalable_dimension
  schedule           = var.schedule

  scalable_target_action {
    max_capacity = var.scalable_target_action.max_capacity
    min_capacity = var.scalable_target_action.min_capacity
  }

  start_time = var.start_time
  end_time   = var.end_time
  timezone   = var.timezone
}