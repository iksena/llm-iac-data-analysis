data "aws_lb_trust_store" "this" {
  arn    = var.arn
  name   = var.name
  region = var.region
}