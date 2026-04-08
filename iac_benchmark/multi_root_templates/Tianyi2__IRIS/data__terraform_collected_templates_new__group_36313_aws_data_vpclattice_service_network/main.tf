data "aws_vpclattice_service_network" "this" {
  region                     = var.region
  service_network_identifier = var.service_network_identifier
}