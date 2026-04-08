resource "aws_proxy_protocol_policy" "this" {
  region         = var.region
  load_balancer  = var.load_balancer
  instance_ports = var.instance_ports
}