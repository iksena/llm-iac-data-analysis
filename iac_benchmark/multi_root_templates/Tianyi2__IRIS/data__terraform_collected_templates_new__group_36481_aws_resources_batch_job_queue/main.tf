resource "aws_batch_job_queue" "this" {
  region                = var.region
  name                  = var.name
  priority              = var.priority
  state                 = var.state
  scheduling_policy_arn = var.scheduling_policy_arn
  tags                  = var.tags

  dynamic "compute_environment_order" {
    for_each = var.compute_environment_order
    content {
      compute_environment = compute_environment_order.value.compute_environment
      order               = compute_environment_order.value.order
    }
  }

  dynamic "job_state_time_limit_action" {
    for_each = var.job_state_time_limit_action
    content {
      action           = job_state_time_limit_action.value.action
      max_time_seconds = job_state_time_limit_action.value.max_time_seconds
      reason           = job_state_time_limit_action.value.reason
      state            = job_state_time_limit_action.value.state
    }
  }

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}