resource "aws_lightsail_lb" "this" {
  name              = var.name
  instance_port     = var.instance_port
  health_check_path = var.health_check_path
  ip_address_type   = var.ip_address_type
  region            = var.region
  tags              = var.tags
}