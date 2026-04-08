resource "aws_ecs_task_set" "this" {
  service         = var.service
  cluster         = var.cluster
  task_definition = var.task_definition

  region                    = var.region
  external_id               = var.external_id
  force_delete              = var.force_delete
  launch_type               = var.launch_type
  platform_version          = var.platform_version
  wait_until_stable         = var.wait_until_stable
  wait_until_stable_timeout = var.wait_until_stable_timeout
  tags                      = var.tags

  dynamic "capacity_provider_strategy" {
    for_each = var.capacity_provider_strategy
    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = capacity_provider_strategy.value.base
    }
  }

  dynamic "load_balancer" {
    for_each = var.load_balancer != null ? [var.load_balancer] : []
    content {
      container_name     = load_balancer.value.container_name
      load_balancer_name = load_balancer.value.load_balancer_name
      target_group_arn   = load_balancer.value.target_group_arn
      container_port     = load_balancer.value.container_port
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

  dynamic "scale" {
    for_each = var.scale != null ? [var.scale] : []
    content {
      unit  = scale.value.unit
      value = scale.value.value
    }
  }

  dynamic "service_registries" {
    for_each = var.service_registries != null ? [var.service_registries] : []
    content {
      registry_arn   = service_registries.value.registry_arn
      port           = service_registries.value.port
      container_port = service_registries.value.container_port
      container_name = service_registries.value.container_name
    }
  }
}