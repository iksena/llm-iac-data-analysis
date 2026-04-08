resource "aws_cloudwatch_event_api_destination" "this" {
  region                           = var.region
  name                             = var.name
  description                      = var.description
  invocation_endpoint              = var.invocation_endpoint
  http_method                      = var.http_method
  invocation_rate_limit_per_second = var.invocation_rate_limit_per_second
  connection_arn                   = var.connection_arn
}