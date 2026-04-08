resource "aws_elb_attachment" "this" {
  region   = var.region
  elb      = var.elb
  instance = var.instance
}