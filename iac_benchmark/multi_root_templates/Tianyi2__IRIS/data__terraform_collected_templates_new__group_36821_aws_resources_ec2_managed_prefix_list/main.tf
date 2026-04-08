resource "aws_ec2_managed_prefix_list" "this" {
  region         = var.region
  address_family = var.address_family
  max_entries    = var.max_entries
  name           = var.name
  tags           = var.tags

  dynamic "entry" {
    for_each = var.entry != null ? var.entry : []
    content {
      cidr        = entry.value.cidr
      description = entry.value.description
    }
  }
}