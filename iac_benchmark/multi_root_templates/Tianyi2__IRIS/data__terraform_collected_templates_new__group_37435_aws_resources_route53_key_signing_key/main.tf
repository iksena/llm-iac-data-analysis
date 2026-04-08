resource "aws_route53_key_signing_key" "this" {
  hosted_zone_id             = var.hosted_zone_id
  key_management_service_arn = var.key_management_service_arn
  name                       = var.name
  status                     = var.status

  timeouts {
    create = var.timeouts.create
    update = var.timeouts.update
    delete = var.timeouts.delete
  }
}