resource "aws_nat_gateway" "this" {
  allocation_id                      = var.allocation_id
  connectivity_type                  = var.connectivity_type
  private_ip                         = var.private_ip
  region                             = var.region
  subnet_id                          = var.subnet_id
  secondary_allocation_ids           = var.secondary_allocation_ids
  secondary_private_ip_address_count = var.secondary_private_ip_address_count
  secondary_private_ip_addresses     = var.secondary_private_ip_addresses
  tags                               = var.tags

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}