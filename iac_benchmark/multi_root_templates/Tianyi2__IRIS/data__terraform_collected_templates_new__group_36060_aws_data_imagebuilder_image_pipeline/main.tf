data "aws_imagebuilder_image_pipeline" "this" {
  arn    = var.arn
  region = var.region
}