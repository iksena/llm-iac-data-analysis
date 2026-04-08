resource "aws_vpc_ipam_resource_discovery" "this" {
  region      = var.region
  description = var.description
  tags        = var.tags

  dynamic "operating_regions" {
    for_each = var.operating_regions
    content {
      region_name = operating_regions.value.region_name
    }
  }
}