data "aws_cloudwatch_event_connection" "this" {
  name   = var.name
  region = var.region
}