resource "aws_codedeploy_app" "this" {
  region           = var.region
  name             = var.name
  compute_platform = var.compute_platform
  tags             = var.tags
}