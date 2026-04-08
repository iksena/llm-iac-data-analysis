resource "aws_sagemaker_model_package_group_policy" "this" {
  region                   = var.region
  model_package_group_name = var.model_package_group_name
  resource_policy          = var.resource_policy
}