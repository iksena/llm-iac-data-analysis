resource "aws_route53_traffic_policy" "this" {
  name     = var.name
  document = var.document
  comment  = var.comment
}