resource "aws_vpclattice_access_log_subscription" "this" {
  destination_arn          = var.destination_arn
  resource_identifier      = var.resource_identifier
  region                   = var.region
  service_network_log_type = var.service_network_log_type
}