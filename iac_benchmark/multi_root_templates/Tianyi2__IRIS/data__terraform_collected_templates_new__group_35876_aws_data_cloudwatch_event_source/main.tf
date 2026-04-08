data "aws_cloudwatch_event_source" "this" {
  region      = var.region
  name_prefix = var.name_prefix
}