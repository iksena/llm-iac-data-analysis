data "aws_vpclattice_service" "this" {
  region             = var.region
  name               = var.name
  service_identifier = var.service_identifier
}