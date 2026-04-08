data "aws_appintegrations_event_integration" "this" {
  name   = var.name
  region = var.region
}