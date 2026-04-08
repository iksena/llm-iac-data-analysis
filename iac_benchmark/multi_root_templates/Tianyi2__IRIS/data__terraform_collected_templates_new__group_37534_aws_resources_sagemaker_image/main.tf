resource "aws_sagemaker_image" "this" {
  image_name   = var.image_name
  role_arn     = var.role_arn
  display_name = var.display_name
  description  = var.description
  tags         = var.tags
}