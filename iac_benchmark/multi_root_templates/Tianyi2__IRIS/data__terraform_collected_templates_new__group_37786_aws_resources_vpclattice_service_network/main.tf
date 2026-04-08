resource "aws_vpclattice_service_network_service_association" "this" {
  region                     = var.region
  service_identifier         = var.service_identifier
  service_network_identifier = var.service_network_identifier
  tags                       = var.tags

  timeouts {
    create = "5m"
    delete = "5m"
  }
}