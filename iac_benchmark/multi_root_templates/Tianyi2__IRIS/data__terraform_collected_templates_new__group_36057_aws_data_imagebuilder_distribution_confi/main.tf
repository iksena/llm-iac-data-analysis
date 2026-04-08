data "aws_imagebuilder_distribution_configuration" "this" {
  arn    = var.arn
  region = var.region
}