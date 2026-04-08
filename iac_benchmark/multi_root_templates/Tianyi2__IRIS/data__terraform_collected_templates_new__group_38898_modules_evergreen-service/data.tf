data "aws_vpc" "evergreen" {
  filter {
    name   = "tag:Name"
    values = ["evergreen-prod-vpc"]
  }
}

data "aws_lb" "evergreen_gateway" {
  name = "evergreen-prod-gateway"
}

data "aws_lb_listener" "gateway" {
  load_balancer_arn = data.aws_lb.evergreen_gateway.arn
  port              = 443
}

data "aws_ecs_cluster" "evergreen" {
  cluster_name = "evergreen-prod-cluster"
}

data "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
}
