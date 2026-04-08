resource "aws_sagemaker_studio_lifecycle_config" "this" {
  region                           = var.region
  studio_lifecycle_config_name     = var.studio_lifecycle_config_name
  studio_lifecycle_config_app_type = var.studio_lifecycle_config_app_type
  studio_lifecycle_config_content  = var.studio_lifecycle_config_content
  tags                             = var.tags
}