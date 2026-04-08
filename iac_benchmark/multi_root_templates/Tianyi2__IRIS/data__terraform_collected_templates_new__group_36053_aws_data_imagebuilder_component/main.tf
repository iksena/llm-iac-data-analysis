data "aws_imagebuilder_component" "this" {
  arn    = var.arn
  region = var.region
}