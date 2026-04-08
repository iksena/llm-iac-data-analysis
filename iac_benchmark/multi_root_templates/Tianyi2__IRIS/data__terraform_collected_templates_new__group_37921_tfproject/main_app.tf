# ECR Repo creation for Docker images:

resource "aws_ecr_repository" "dockerrepo" {
  name                 = "tf-dockerrepo"
  image_tag_mutability = "MUTABLE"
  image_scanning_configuration {
    scan_on_push = true
  }
}



# To create a ECS - Task definition:

resource "aws_ecs_task_definition" "app_task" {
  family                   = "app-task"
  container_definitions    = <<EOF
  [
    {
    "name": "app",
    "image": "${aws_ecr_repository.dockerrepo.repository_url}:${var.image_tag}",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 80, 
        "hostPort": 80
      }
    ],
    "memory": 512,
    "cpu": 256
    }
  ]
  EOF
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = 512
  cpu                      = 256
  execution_role_arn       = aws_iam_role.ecsTaskExecutionRole.arn

}


# task definition execution role creation:

resource "aws_iam_role" "ecsTaskExecutionRole" {
  name               = "ecsTaskExecutionRole-tf"
  assume_role_policy = data.aws_iam_policy_document.aws_iam_policy_document.json
}


# Create Assume role policy using data block:

data "aws_iam_policy_document" "aws_iam_policy_document" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}


# Create ECS Cluster:

resource "aws_ecs_cluster" "my_cluster" {
  name = "my-app-cluster"
}


# Create the ECS service:

resource "aws_ecs_service" "ecs_service" {
  name            = "ecs-service"
  launch_type     = "FARGATE"
  desired_count   = 1
  cluster         = aws_ecs_cluster.my_cluster.id
  task_definition = aws_ecs_task_definition.app_task.arn

  network_configuration {
    subnets          = module.vpc.public_subnets
    security_groups  = ["${aws_security_group.alb_sg.id}"]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "app"
    container_port   = 80

  }
}



# Attached execution policy document to the role:

resource "aws_iam_role_policy_attachment" "attach" {
  role       = aws_iam_role.ecsTaskExecutionRole.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

