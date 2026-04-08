resource "aws_vpclattice_service_network" "this" {
  name      = var.name
  region    = var.region
  auth_type = var.auth_type
  tags      = var.tags
}