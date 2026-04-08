data "aws_imagebuilder_container_recipe" "this" {
  arn    = var.arn
  region = var.region
}