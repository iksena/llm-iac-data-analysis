data "aws_iam_role" "ecs_exec" {
  name = "ecsTaskExecutionRole"
}

resource "aws_ecs_cluster" "chatroom" {
  name = var.cluster_name
}

resource "aws_ecs_task_definition" "backend" {
  family                   = var.service_name
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "2048"
  execution_role_arn       = data.aws_iam_role.ecs_exec.arn
  task_role_arn            = data.aws_iam_role.ecs_exec.arn
  container_definitions = jsonencode([
    {
      name      = "chatroom-backend-tf"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      essential = true
      portMappings = [
        { containerPort = 8080, protocol = "tcp" }
      ]
      environment = [
        { name = "ALLOWED_ORIGIN", value = var.allowed_origin }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.service_name}"
          awslogs-region        = var.region
          awslogs-stream-prefix = "backend"
        }
      }
    }
  ])
  depends_on = [
    aws_cloudwatch_log_group.backend
  ]
}

resource "aws_ecs_service" "chatroom" {
  name            = var.service_name
  cluster         = aws_ecs_cluster.chatroom.id
  task_definition = aws_ecs_task_definition.backend.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.default.ids
    security_groups  = [data.aws_security_group.default.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.chatroom-tg.arn
    container_name   = "chatroom-backend-tf"
    container_port   = 8080
  }

  depends_on = [
    aws_alb_listener.http,
    aws_ecs_task_definition.backend
  ]
}
