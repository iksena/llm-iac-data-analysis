data "aws_imagebuilder_image_recipe" "this" {
  arn    = var.arn
  region = var.region
}