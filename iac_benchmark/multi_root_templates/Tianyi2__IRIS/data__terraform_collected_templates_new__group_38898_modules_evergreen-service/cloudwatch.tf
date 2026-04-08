resource "aws_cloudwatch_log_group" "this" {
  name = "/ecs/evergreen/${var.service_name}"

  retention_in_days = 30
}
