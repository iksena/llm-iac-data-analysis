resource "aws_wafregional_web_acl_association" "this" {
  region       = var.region
  web_acl_id   = var.web_acl_id
  resource_arn = var.resource_arn

  timeouts {
    create = var.timeouts.create
  }
}