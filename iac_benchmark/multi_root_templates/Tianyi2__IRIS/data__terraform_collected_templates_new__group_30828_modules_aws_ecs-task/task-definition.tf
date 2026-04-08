resource "aws_ecs_task_definition" "task-definition" {
  family                = var.task_name
  container_definitions = var.task_definition
  network_mode          = var.network_mode
  task_role_arn         = var.task_role_arn
  execution_role_arn    = var.execution_role_arn

  dynamic "volume" {
    for_each = var.volume_mapping
    content {
      name = volume.key
      host_path = volume.value
    }
  }


  tags = {
    "Terraform" = "true"
  }
}