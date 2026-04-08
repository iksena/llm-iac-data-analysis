resource "aws_vpclattice_service_network_resource_association" "this" {
  resource_configuration_identifier = var.resource_configuration_identifier
  service_network_identifier        = var.service_network_identifier
  region                            = var.region
  tags                              = var.tags

  timeouts {
    create = var.timeouts_create
    delete = var.timeouts_delete
  }
}