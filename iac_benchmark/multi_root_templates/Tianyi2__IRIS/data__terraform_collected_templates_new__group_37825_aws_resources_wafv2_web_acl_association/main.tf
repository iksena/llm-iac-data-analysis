resource "aws_wafv2_web_acl_association" "this" {
  region       = var.region
  resource_arn = var.resource_arn
  web_acl_arn  = var.web_acl_arn

  timeouts {
    create = var.timeouts_create
  }
}