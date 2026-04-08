data "aws_route53_zone" "this" {
  zone_id      = var.zone_id
  name         = var.name
  private_zone = var.private_zone
  vpc_id       = var.vpc_id
  tags         = var.tags
}