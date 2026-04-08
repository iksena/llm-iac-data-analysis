resource "aws_lightsail_lb_attachment" "this" {
  instance_name = var.instance_name
  lb_name       = var.lb_name
  region        = var.region
}