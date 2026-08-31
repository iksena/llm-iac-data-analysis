################### IAM for ECS ###################
resource "aws_iam_role" "ecs_task_execution" {
  name = "ecs-task-execution"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com" ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_task" {
  name               = "ecs-task"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": ["ecs-tasks.amazonaws.com"]
      },
      "Effect": "Allow"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_policy" {
  role       = aws_iam_role.ecs_task_execution.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}


################### ECS ###################
resource "aws_ecs_cluster" "main" {
  name = "my-ecs-cluster"
}

resource "aws_ecs_service" "web_backend" {
  name            = var.application_name
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web_backend.arn
  desired_count   = 2 # only works initially

  # 20% FARGATE, 80% FARGATE_SPOT
  capacity_provider_strategy {
    base              = 1
    capacity_provider = "FARGATE"
    weight            = 20
  }

  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE_SPOT"
    weight            = 80
  }

  deployment_circuit_breaker {
    enable   = true
    rollback = true
  }

  network_configuration {
    subnets         = aws_subnet.public[*].id
    security_groups = [aws_security_group.ecs_task.id]
    assign_public_ip = true
  }

  deployment_controller {
    type = "ECS"
  }

  load_balancer {
    container_name   = var.application_name
    container_port   = var.application_port
    target_group_arn = aws_lb_target_group.main.arn
  }

  lifecycle {
    ignore_changes = [
      # let auto-scaling manage
      # source: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#ignoring-changes-to-desired-count
      desired_count,
      # task_definition is only for initial apply
      task_definition
    ]
  }

  # source: https://github.com/hashicorp/terraform/issues/12634#issuecomment-313215022
  depends_on = [aws_lb_listener.http]
}


################### ECS Task: How to launch new containers ###################
resource "aws_ecs_task_definition" "web_backend" {
  family                   = var.application_name
  task_role_arn            = aws_iam_role.ecs_task.arn
  execution_role_arn       = aws_iam_role.ecs_task_execution.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512

  # Image: We use dummy nginx to pass health check at the first launch. Image is controlled by CI/CD in the future
  # Env: We can even use "environmentFiles" to pass env files on S3
  container_definitions = <<TASK_DEFINITION
[
  {
    "name": "${var.application_name}",
    "image": "nginx:1.23.1",
    "essential": true,
    "portMappings": [
      {
        "containerPort": ${var.application_port},
        "hostPort": ${var.application_port}
      }
    ],
    "healthCheck": {
      "retries": 3,
      "command": [
          "CMD-SHELL",
          "curl -f http://localhost:${var.application_port}/ || exit 1"
      ],
      "timeout": 5,
      "interval": 30,
      "startPeriod": null
    },
    "environment": [
      {
        "name": "DATABASE_URL",
        "value": "postgresql://${aws_db_instance.main.username}:${aws_db_instance.main.password}@${aws_db_instance.main.address}:${aws_db_instance.main.port}"
      },
      {
        "name": "DATABASE_NAME",
        "value": "mydb"
      }
    ]
  }
]
TASK_DEFINITION

  depends_on = [aws_db_instance.main]

  lifecycle {
    ignore_changes = all
  }
}


################### ECS Auto-Scaling ###################
resource "aws_appautoscaling_target" "web_backend" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.web_backend.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "scale-by-memory"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.web_backend.resource_id
  scalable_dimension = aws_appautoscaling_target.web_backend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web_backend.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 80

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "scale-by-cpu"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.web_backend.resource_id
  scalable_dimension = aws_appautoscaling_target.web_backend.scalable_dimension
  service_namespace  = aws_appautoscaling_target.web_backend.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 80

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}
