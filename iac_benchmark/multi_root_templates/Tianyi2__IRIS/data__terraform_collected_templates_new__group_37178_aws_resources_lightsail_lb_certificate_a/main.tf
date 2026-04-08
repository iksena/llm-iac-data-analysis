resource "aws_lightsail_lb_certificate_attachment" "this" {
  certificate_name = var.certificate_name
  lb_name          = var.lb_name
  region           = var.region
}