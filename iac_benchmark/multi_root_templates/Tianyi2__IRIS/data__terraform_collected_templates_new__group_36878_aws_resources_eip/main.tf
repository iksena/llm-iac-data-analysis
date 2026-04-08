resource "aws_eip" "this" {
  region                    = var.region
  address                   = var.address
  associate_with_private_ip = var.associate_with_private_ip
  customer_owned_ipv4_pool  = var.customer_owned_ipv4_pool
  domain                    = var.domain
  instance                  = var.instance
  ipam_pool_id              = var.ipam_pool_id
  network_border_group      = var.network_border_group
  network_interface         = var.network_interface
  public_ipv4_pool          = var.public_ipv4_pool
  tags                      = var.tags

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      read   = try(timeouts.value.read, null)
      update = try(timeouts.value.update, null)
      delete = try(timeouts.value.delete, null)
    }
  }
}