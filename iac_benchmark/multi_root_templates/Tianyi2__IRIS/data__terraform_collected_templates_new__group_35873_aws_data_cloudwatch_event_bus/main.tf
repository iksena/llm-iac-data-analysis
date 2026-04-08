data "aws_cloudwatch_event_bus" "this" {
  name   = var.name
  region = var.region
}