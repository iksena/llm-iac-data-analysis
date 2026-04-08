data "aws_imagebuilder_image" "this" {
  arn    = var.arn
  region = var.region
}