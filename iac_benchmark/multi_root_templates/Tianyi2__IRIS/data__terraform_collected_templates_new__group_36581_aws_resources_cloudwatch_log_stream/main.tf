resource "aws_cloudwatch_log_stream" "this" {
  region         = var.region
  name           = var.name
  log_group_name = var.log_group_name
}