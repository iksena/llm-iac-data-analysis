resource "aws_lightsail_static_ip" "this" {
  name   = var.name
  region = var.region
}