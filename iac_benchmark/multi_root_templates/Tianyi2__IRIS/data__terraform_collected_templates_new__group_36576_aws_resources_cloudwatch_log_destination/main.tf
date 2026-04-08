resource "aws_cloudwatch_log_destination_policy" "this" {
  region           = var.region
  destination_name = var.destination_name
  access_policy    = var.access_policy
  force_update     = var.force_update
}