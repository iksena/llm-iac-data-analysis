resource "aws_sagemaker_model_package_group" "this" {
  region                          = var.region
  model_package_group_name        = var.model_package_group_name
  model_package_group_description = var.model_package_group_description
  tags                            = var.tags
}