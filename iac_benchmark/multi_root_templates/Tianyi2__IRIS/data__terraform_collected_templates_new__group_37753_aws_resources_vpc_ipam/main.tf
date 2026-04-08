resource "aws_vpc_ipam" "this" {
  region             = var.region
  cascade            = var.cascade
  description        = var.description
  enable_private_gua = var.enable_private_gua
  metered_account    = var.metered_account
  tier               = var.tier
  tags               = var.tags

  dynamic "operating_regions" {
    for_each = var.operating_regions
    content {
      region_name = operating_regions.value.region_name
    }
  }
}