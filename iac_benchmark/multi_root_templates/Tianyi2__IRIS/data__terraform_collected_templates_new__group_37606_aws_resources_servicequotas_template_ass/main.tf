resource "aws_servicequotas_template_association" "this" {
  region       = var.region
  skip_destroy = var.skip_destroy
}