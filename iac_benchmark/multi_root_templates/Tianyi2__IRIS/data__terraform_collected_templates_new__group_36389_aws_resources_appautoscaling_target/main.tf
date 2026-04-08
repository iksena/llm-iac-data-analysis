resource "aws_appautoscaling_target" "this" {
  region             = var.region
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = var.resource_id
  role_arn           = var.role_arn
  scalable_dimension = var.scalable_dimension
  service_namespace  = var.service_namespace
  tags               = var.tags

  dynamic "suspended_state" {
    for_each = var.suspended_state != null ? [var.suspended_state] : []
    content {
      dynamic_scaling_in_suspended  = suspended_state.value.dynamic_scaling_in_suspended
      dynamic_scaling_out_suspended = suspended_state.value.dynamic_scaling_out_suspended
      scheduled_scaling_suspended   = suspended_state.value.scheduled_scaling_suspended
    }
  }
}