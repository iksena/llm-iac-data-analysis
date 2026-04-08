resource "aws_cloudwatch_log_group" "backend" {
  name              = "/ecs/${var.service_name}"
  retention_in_days = 14
}
