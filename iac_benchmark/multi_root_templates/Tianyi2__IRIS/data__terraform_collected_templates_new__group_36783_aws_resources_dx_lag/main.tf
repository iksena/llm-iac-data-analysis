resource "aws_dx_lag" "this" {
  region                = var.region
  name                  = var.name
  connections_bandwidth = var.connections_bandwidth
  location              = var.location
  connection_id         = var.connection_id
  force_destroy         = var.force_destroy
  provider_name         = var.provider_name
  tags                  = var.tags
}