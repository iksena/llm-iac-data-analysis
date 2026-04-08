resource "aws_cloudwatch_log_delivery_destination_policy" "this" {
  delivery_destination_name   = var.delivery_destination_name
  delivery_destination_policy = var.delivery_destination_policy
  region                      = var.region
}