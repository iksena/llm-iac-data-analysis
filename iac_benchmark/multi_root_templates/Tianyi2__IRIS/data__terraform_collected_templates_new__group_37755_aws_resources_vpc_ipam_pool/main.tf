resource "aws_vpc_ipam_pool" "this" {
  region                            = var.region
  address_family                    = var.address_family
  allocation_default_netmask_length = var.allocation_default_netmask_length
  allocation_max_netmask_length     = var.allocation_max_netmask_length
  allocation_min_netmask_length     = var.allocation_min_netmask_length
  allocation_resource_tags          = var.allocation_resource_tags
  auto_import                       = var.auto_import
  aws_service                       = var.aws_service
  cascade                           = var.cascade
  description                       = var.description
  ipam_scope_id                     = var.ipam_scope_id
  locale                            = var.locale
  publicly_advertisable             = var.publicly_advertisable
  public_ip_source                  = var.public_ip_source
  source_ipam_pool_id               = var.source_ipam_pool_id
  tags                              = var.tags
}