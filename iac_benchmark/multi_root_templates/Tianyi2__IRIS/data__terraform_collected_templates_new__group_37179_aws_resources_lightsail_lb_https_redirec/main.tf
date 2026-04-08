resource "aws_lightsail_lb_https_redirection_policy" "this" {
  enabled = var.enabled
  lb_name = var.lb_name
  region  = var.region
}