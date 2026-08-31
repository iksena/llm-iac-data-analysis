data "aws_vpc" "current" {}

data "aws_subnets" "current" {
  tags = {
    "Scheme" = "private"
  }
}

data "aws_route53_zone" "hosted_zones" {
  for_each = { for domain in var.domains : domain.domain => domain }
  name     = each.value.zone_name
}

# Find a certificate that is issued
data "aws_acm_certificate" "certificates" {
  for_each = { for domain in var.domains : domain.domain => domain }
  domain   = each.value.zone_name
  statuses = ["ISSUED"]
}

data "aws_subnets" "private" {

  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.current.id]
  }

  filter {
    name   = "tag:Scheme"
    values = ["private"]
  }
}
