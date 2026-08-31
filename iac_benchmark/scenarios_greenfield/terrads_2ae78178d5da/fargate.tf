variable "image_tag" {
  default = "v1"
}

data "aws_ecr_repository" "ecr_repo" {
  name = "flask-app"
}

data "aws_iam_role" "execution_role" {
  name = "ecsTaskExecutionRole" # Policy: AmazonECSTaskExecutionRolePolicy
}

data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name = "/ecs/"
}

resource "aws_security_group" "sg" {
  name   = "ecs_app_access"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_ecs_cluster" "cluster" {
  name = "cluster-exp"

  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.log_group.name
      }
    }
  }
}

resource "aws_ecs_task_definition" "task_def" {
  family                   = "task-exp"
  execution_role_arn       = data.aws_iam_role.execution_role.arn
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  requires_compatibilities = ["FARGATE"]
  container_definitions = jsonencode([
    {
      name      = "flask-app-container"
      image     = "${data.aws_ecr_repository.ecr_repo.repository_url}:${var.image_tag}"
      essential = true
      portMappings = [
        {
          protocol      = "tcp"
          containerPort = 5000
        }
      ]
      "logConfiguration" : {
        "logDriver" : "awslogs",
        "options" : {
          "awslogs-group" : "${aws_cloudwatch_log_group.log_group.name}",
          "awslogs-region": "eu-central-1",
          "awslogs-stream-prefix" : "ecs"
        }
      }
    }
  ])
}

resource "aws_ecs_service" "svc" {
  name            = "service-exp"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task_def.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.all.ids
    security_groups  = [aws_security_group.sg.id]
    assign_public_ip = true
  }
}
