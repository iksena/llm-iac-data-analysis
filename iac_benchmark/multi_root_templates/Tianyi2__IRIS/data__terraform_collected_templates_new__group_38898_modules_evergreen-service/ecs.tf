resource "aws_ecs_task_definition" "this" {
  family = var.service_name

  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = var.task_role_arn

  runtime_platform {
    cpu_architecture        = var.runtime_platform_architecture
    operating_system_family = var.runtime_platform_operating_system
  }

  container_definitions = jsonencode([
    for container in var.containers : {
      name      = container.container_name
      image     = container.image
      cpu       = container.cpu
      memory    = container.memory
      essential = container.essential
      environment = [
        for key, value in container.environment : {
          name  = key
          value = value
        }
      ]
      portMappings = [
        for port in container.ports : {
          containerPort = port.container_port
          protocol      = port.protocol
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.this.name
          awslogs-region        = "eu-north-1"
          awslogs-stream-prefix = "ecs/evergreen/${var.service_name}"
        }
      }
      healthCheck = container.healthcheck == null ? null : {
        command = container.healthcheck.command
      }
      hostname = container.networking == null ? null : container.networking.hostname
    }
  ])
}

resource "aws_ecs_service" "this" {
  name = var.service_name

  desired_count = var.task_count
  cluster       = data.aws_ecs_cluster.evergreen.id

  force_new_deployment = true
  task_definition      = aws_ecs_task_definition.this.arn

  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"

  health_check_grace_period_seconds = var.alb_health_check_grace_period_seconds

  load_balancer {
    container_name   = var.target_group_container_name
    container_port   = var.target_group_container_port
    target_group_arn = aws_lb_target_group.this.arn
  }

  network_configuration {
    subnets          = var.vpc_subnets
    security_groups  = [var.vpc_security_group]
    assign_public_ip = false
  }
}
