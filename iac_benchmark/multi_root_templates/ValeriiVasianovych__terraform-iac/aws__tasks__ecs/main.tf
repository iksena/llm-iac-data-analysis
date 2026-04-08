terraform {
  backend "s3" {
    bucket       = "terrafrom-tfstate-file-s3-bucket"
    encrypt      = true
    key          = "aws/tfstates/tasks/ecs/terraform.tfstate"
    region       = "us-east-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = var.region

  default_tags {
    tags = {
      Name        = "ECS Cluster"
      Environment = var.env
      Owner       = "Valerii Vasianovych"
    }
  }
}

# Create Fargate ECS Cluster
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs-cluster-${var.env}"
}

# Create Task Definition
resource "aws_ecs_task_definition" "nginx" {
  family                   = "nginx-${var.env}"
  requires_compatibilities = ["FARGATE"]
  network_mode            = "awsvpc"
  cpu                     = 256
  memory                  = 512
  execution_role_arn      = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx:latest"
      essential = true
      portMappings = [
        {
          containerPort = 80
          protocol      = "tcp"
        }
      ]
    }
  ])
}

# Create IAM role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecs-task-execution-role-${var.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Attach AWS managed policy for ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Create ECS Service
resource "aws_ecs_service" "nginx" {
  name            = "nginx-service-${var.env}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.nginx.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = data.aws_subnets.subnets.ids
    security_groups  = [aws_security_group.nginx_service.id]
    assign_public_ip = true
  }
}

# Create Security Group for the ECS Service
resource "aws_security_group" "nginx_service" {
  name        = "nginx-service-sg-${var.env}"
  description = "Security group for Nginx ECS service"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
