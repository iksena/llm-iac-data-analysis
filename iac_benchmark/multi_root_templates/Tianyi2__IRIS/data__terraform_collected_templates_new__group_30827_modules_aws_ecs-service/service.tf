resource "aws_ecs_service" "service-replica" {
  count = var.scheduling_strategy == "REPLICA" ? 1 : 0

  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_task_count
  force_new_deployment = true

  ordered_placement_strategy {
    type  = var.ordered_placement_strategy_type
    field = var.ordered_placement_strategy_field
  }

  dynamic "load_balancer" {
    for_each = var.attach_loadbalancer
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.key
      container_port   = load_balancer.value.container_port
    }

  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }

  launch_type = "EC2"
  scheduling_strategy = "REPLICA"

  dynamic service_registries {
    for_each = var.enable_service_discovery ? {"service_arn" = "${aws_service_discovery_service.service[0].arn}"} : {}
    content{
      registry_arn = each.value.service_arn    
    }
  }

}

resource "aws_ecs_service" "service-daemon" {
  count = var.scheduling_strategy == "DAEMON" ? 1 : 0

  name            = var.service_name
  cluster         = var.cluster_id
  task_definition = var.task_definition_arn
  desired_count   = var.desired_task_count
  force_new_deployment = true

  dynamic "load_balancer" {
    for_each = var.attach_loadbalancer
    content {
      target_group_arn = load_balancer.value.target_group_arn
      container_name   = load_balancer.key
      container_port   = load_balancer.value.container_port
    }

  }
  # Optional: Allow external changes without Terraform plan difference(for example ASG)
  lifecycle {
    ignore_changes = [desired_count]
  }

  launch_type = "EC2"
  scheduling_strategy = "DAEMON"

  dynamic service_registries {
    for_each = var.enable_service_discovery ? {"service_arn" = "${aws_service_discovery_service.service[0].arn}"} : {}
    content{
      registry_arn = each.value.service_arn    
    }
  }

}


