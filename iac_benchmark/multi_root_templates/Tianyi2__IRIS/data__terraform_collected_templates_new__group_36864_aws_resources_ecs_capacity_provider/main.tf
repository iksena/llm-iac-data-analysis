resource "aws_ecs_capacity_provider" "this" {
  region = var.region
  name   = var.name
  tags   = var.tags

  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.auto_scaling_group_provider.auto_scaling_group_arn
    managed_draining               = var.auto_scaling_group_provider.managed_draining
    managed_termination_protection = var.auto_scaling_group_provider.managed_termination_protection

    dynamic "managed_scaling" {
      for_each = var.auto_scaling_group_provider.managed_scaling != null ? [var.auto_scaling_group_provider.managed_scaling] : []
      content {
        instance_warmup_period    = managed_scaling.value.instance_warmup_period
        maximum_scaling_step_size = managed_scaling.value.maximum_scaling_step_size
        minimum_scaling_step_size = managed_scaling.value.minimum_scaling_step_size
        status                    = managed_scaling.value.status
        target_capacity           = managed_scaling.value.target_capacity
      }
    }
  }
}