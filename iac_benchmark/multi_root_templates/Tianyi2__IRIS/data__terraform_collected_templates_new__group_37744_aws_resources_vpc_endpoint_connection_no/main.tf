resource "aws_vpc_endpoint_connection_notification" "this" {
  region                      = var.region
  vpc_endpoint_service_id     = var.vpc_endpoint_service_id
  vpc_endpoint_id             = var.vpc_endpoint_id
  connection_notification_arn = var.connection_notification_arn
  connection_events           = var.connection_events
}