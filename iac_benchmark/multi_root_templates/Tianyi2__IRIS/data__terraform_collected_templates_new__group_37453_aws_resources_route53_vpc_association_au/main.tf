resource "aws_route53_vpc_association_authorization" "this" {
  zone_id    = var.zone_id
  vpc_id     = var.vpc_id
  vpc_region = var.vpc_region

  dynamic "timeouts" {
    for_each = var.timeouts != null ? [var.timeouts] : []
    content {
      create = timeouts.value.create
      read   = timeouts.value.read
      delete = timeouts.value.delete
    }
  }
}