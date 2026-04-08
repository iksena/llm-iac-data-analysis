data "aws_imagebuilder_infrastructure_configuration" "this" {
  arn    = var.arn
  region = var.region
}