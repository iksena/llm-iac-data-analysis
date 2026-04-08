data "aws_wafv2_ip_set" "this" {
  region = var.region
  name   = var.name
  scope  = var.scope
}