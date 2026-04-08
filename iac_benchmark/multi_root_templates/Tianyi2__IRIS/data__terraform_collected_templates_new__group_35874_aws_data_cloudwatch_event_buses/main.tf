data "aws_cloudwatch_event_buses" "this" {
  region      = var.region
  name_prefix = var.name_prefix
}