##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  private_zones = {
    for k, v in var.zones : k => {
      domain_name = v.domain_name
      comment     = v.comment
      tags        = v.tags
      vpc = {
        vpc_id     = var.vpc_id
        vpc_region = data.aws_region.current.name
      }
    } if try(v.private, false) == true
  }
  public_zones = {
    for k, v in var.zones : k => {
      domain_name = v.domain_name
      comment     = v.comment
      tags        = v.tags
    } if try(v.private, false) != true
  }

  all_zones = merge(local.private_zones, local.public_zones)
}

resource "aws_route53_zone" "this" {
  for_each          = { for k, v in local.all_zones : k => v }
  name              = lookup(each.value, "domain_name", each.key)
  comment           = lookup(each.value, "comment", null)
  force_destroy     = lookup(each.value, "force_destroy", false)
  delegation_set_id = lookup(each.value, "delegation_set_id", null)

  dynamic "vpc" {
    for_each = try(tolist(lookup(each.value, "vpc", [])), [lookup(each.value, "vpc", {})])

    content {
      vpc_id     = vpc.value.vpc_id
      vpc_region = lookup(vpc.value, "vpc_region", null)
    }
  }

  tags = merge(
    lookup(each.value, "tags", {}),
    local.all_tags
  )
  lifecycle {
    ignore_changes = [
      vpc,
    ]
  }
}

resource "aws_route53_vpc_association_authorization" "vpc_association" {
  for_each = {
    for k, v in local.private_zones :
    k => v
    if var.dns_vpc.vpc_id != ""
  }
  vpc_id     = var.dns_vpc.vpc_id
  vpc_region = var.dns_vpc.vpc_region
  zone_id    = aws_route53_zone.this[each.key].zone_id
}

resource "aws_route53_zone_association" "vpc_association" {
  for_each = var.association_zone_ids
  vpc_id   = var.vpc_id
  zone_id  = each.value
}
