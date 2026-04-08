data "aws_ecs_container_definition" "this" {
  region          = var.region
  task_definition = var.task_definition
  container_name  = var.container_name
}