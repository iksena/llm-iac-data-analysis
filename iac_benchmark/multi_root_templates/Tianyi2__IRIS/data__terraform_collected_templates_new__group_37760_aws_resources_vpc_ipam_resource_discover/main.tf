resource "aws_vpc_ipam_resource_discovery_association" "this" {
  region                     = var.region
  ipam_id                    = var.ipam_id
  ipam_resource_discovery_id = var.ipam_resource_discovery_id
  tags                       = var.tags
}