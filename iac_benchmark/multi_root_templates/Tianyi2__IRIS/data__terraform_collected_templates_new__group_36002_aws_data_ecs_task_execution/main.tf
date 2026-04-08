data "aws_ecs_task_execution" "this" {
  cluster         = var.cluster
  task_definition = var.task_definition

  region                  = var.region
  desired_count           = var.desired_count
  client_token            = var.client_token
  enable_ecs_managed_tags = var.enable_ecs_managed_tags
  enable_execute_command  = var.enable_execute_command
  group                   = var.group
  launch_type             = var.launch_type
  platform_version        = var.platform_version
  propagate_tags          = var.propagate_tags
  reference_id            = var.reference_id
  started_by              = var.started_by
  tags                    = var.tags

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      base              = capacity_provider_strategy.value.base
      weight            = capacity_provider_strategy.value.weight
    }
  }

  dynamic "network_configuration" {
    for_each = var.network_configuration != null ? [var.network_configuration] : []
    content {
      subnets          = network_configuration.value.subnets
      security_groups  = network_configuration.value.security_groups
      assign_public_ip = network_configuration.value.assign_public_ip
    }
  }

  dynamic "overrides" {
    for_each = var.overrides != null ? [var.overrides] : []
    content {
      cpu                = overrides.value.cpu
      execution_role_arn = overrides.value.execution_role_arn
      memory             = overrides.value.memory
      task_role_arn      = overrides.value.task_role_arn

      dynamic "container_overrides" {
        for_each = overrides.value.container_overrides
        content {
          command            = container_overrides.value.command
          cpu                = container_overrides.value.cpu
          memory             = container_overrides.value.memory
          memory_reservation = container_overrides.value.memory_reservation
          name               = container_overrides.value.name

          dynamic "environment" {
            for_each = container_overrides.value.environment
            content {
              key   = environment.value.key
              value = environment.value.value
            }
          }

          dynamic "resource_requirements" {
            for_each = container_overrides.value.resource_requirements
            content {
              type  = resource_requirements.value.type
              value = resource_requirements.value.value
            }
          }
        }
      }
    }
  }

  dynamic "placement_constraints" {
    for_each = var.placement_constraints
    content {
      expression = placement_constraints.value.expression
      type       = placement_constraints.value.type
    }
  }

  dynamic "placement_strategy" {
    for_each = var.placement_strategy
    content {
      field = placement_strategy.value.field
      type  = placement_strategy.value.type
    }
  }
}