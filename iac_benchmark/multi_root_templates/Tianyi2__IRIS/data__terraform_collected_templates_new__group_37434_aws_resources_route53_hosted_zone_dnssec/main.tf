resource "aws_route53_hosted_zone_dnssec" "this" {
  hosted_zone_id = var.hosted_zone_id
  signing_status = var.signing_status

  timeouts {
    create = var.timeouts_create
    update = var.timeouts_update
    delete = var.timeouts_delete
  }
}