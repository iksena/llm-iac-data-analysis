resource "aws_ecs_cluster" "cluster" {
  name = "${local.prefix}-cluster"
}

resource "aws_ecs_task_definition" "app" {
  family = "${local.prefix}-app"
  requires_compatibilities = [
    "FARGATE",
  ]
  cpu                = "256"
  memory             = "512"
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  # ダミーのタスク定義
  container_definitions = jsonencode([{
    name  = "web"
    image = "hello-world:latest"
    portMappings = [
      {
        containerPort = 5000
        hostPort      = 5000
      }
    ]
  }])
}

resource "aws_ecs_task_definition" "migrate" {
  family = "${local.prefix}-migrate"
  requires_compatibilities = [
    "FARGATE",
  ]
  cpu                = "256"
  memory             = "512"
  network_mode       = "awsvpc"
  execution_role_arn = aws_iam_role.ecs_task_execution.arn

  # ダミーのタスク定義
  container_definitions = jsonencode([{
    name  = "migrate"
    image = "hello-world:latest"
  }])
}

resource "aws_ecs_service" "app" {
  cluster         = aws_ecs_cluster.cluster.id
  name            = "${local.prefix}-app"
  desired_count   = 0
  task_definition = aws_ecs_task_definition.app.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = data.terraform_remote_state.common.outputs.public_subnets
    security_groups = [
      aws_security_group.ecs_task.id,
    ]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "web"
    container_port   = 5000
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      network_configuration,
      load_balancer,
    ]
  }
}

resource "aws_ecs_service" "migrate" {
  cluster         = aws_ecs_cluster.cluster.id
  name            = "${local.prefix}-migrate"
  desired_count   = 0
  task_definition = aws_ecs_task_definition.migrate.arn
  launch_type     = "FARGATE"

  network_configuration {
    subnets = data.terraform_remote_state.common.outputs.public_subnets
    security_groups = [
      aws_security_group.ecs_task.id,
    ]
    assign_public_ip = true
  }

  lifecycle {
    ignore_changes = [
      desired_count,
      task_definition,
      network_configuration,
    ]
  }
}

resource "aws_cloudwatch_log_group" "ecs_task" {
  name              = "${local.prefix}-ecs-task-logs"
  retention_in_days = 7
}