resource "aws_networkfirewall_vpc_endpoint_association" "this" {
  description  = var.description
  firewall_arn = var.firewall_arn
  region       = var.region
  vpc_id       = var.vpc_id
  tags         = var.tags

  dynamic "subnet_mapping" {
    for_each = var.subnet_mapping
    content {
      ip_address_type = subnet_mapping.value.ip_address_type
      subnet_id       = subnet_mapping.value.subnet_id
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}