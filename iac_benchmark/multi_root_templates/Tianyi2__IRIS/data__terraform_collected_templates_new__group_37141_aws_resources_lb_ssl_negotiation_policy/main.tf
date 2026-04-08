resource "aws_lb_ssl_negotiation_policy" "this" {
  region        = var.region
  name          = var.name
  load_balancer = var.load_balancer
  lb_port       = var.lb_port
  triggers      = var.triggers

  dynamic "attribute" {
    for_each = var.attribute
    content {
      name  = attribute.value.name
      value = attribute.value.value
    }
  }
}