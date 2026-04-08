resource "aws_route53_zone_association" "this" {
  zone_id    = var.zone_id
  vpc_id     = var.vpc_id
  vpc_region = var.vpc_region

  timeouts {
    create = var.create_timeout
    delete = var.delete_timeout
  }
}