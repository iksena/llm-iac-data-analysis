resource "aws_codebuild_fleet" "this" {
  name             = var.name
  base_capacity    = var.base_capacity
  compute_type     = var.compute_type
  environment_type = var.environment_type

  region             = var.region
  fleet_service_role = var.fleet_service_role
  image_id           = var.image_id
  overflow_behavior  = var.overflow_behavior
  tags               = var.tags

  dynamic "compute_configuration" {
    for_each = var.compute_configuration != null ? [var.compute_configuration] : []
    content {
      disk          = compute_configuration.value.disk
      instance_type = compute_configuration.value.instance_type
      machine_type  = compute_configuration.value.machine_type
      memory        = compute_configuration.value.memory
      vcpu          = compute_configuration.value.vcpu
    }
  }

  dynamic "scaling_configuration" {
    for_each = var.scaling_configuration != null ? [var.scaling_configuration] : []
    content {
      max_capacity = scaling_configuration.value.max_capacity
      scaling_type = scaling_configuration.value.scaling_type

      dynamic "target_tracking_scaling_configs" {
        for_each = scaling_configuration.value.target_tracking_scaling_configs != null ? [scaling_configuration.value.target_tracking_scaling_configs] : []
        content {
          metric_type  = target_tracking_scaling_configs.value.metric_type
          target_value = target_tracking_scaling_configs.value.target_value
        }
      }
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnets            = vpc_config.value.subnets
      vpc_id             = vpc_config.value.vpc_id
    }
  }
}