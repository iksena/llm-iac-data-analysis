resource "aws_cloudwatch_log_destination" "this" {
  region     = var.region
  name       = var.name
  role_arn   = var.role_arn
  target_arn = var.target_arn
  tags       = var.tags
}