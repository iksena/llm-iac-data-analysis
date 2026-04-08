resource "aws_sagemaker_app" "this" {
  region            = var.region
  app_name          = var.app_name
  app_type          = var.app_type
  domain_id         = var.domain_id
  space_name        = var.space_name
  user_profile_name = var.user_profile_name
  tags              = var.tags

  dynamic "resource_spec" {
    for_each = var.resource_spec != null ? [var.resource_spec] : []
    content {
      instance_type                 = resource_spec.value.instance_type
      lifecycle_config_arn          = resource_spec.value.lifecycle_config_arn
      sagemaker_image_arn           = resource_spec.value.sagemaker_image_arn
      sagemaker_image_version_alias = resource_spec.value.sagemaker_image_version_alias
      sagemaker_image_version_arn   = resource_spec.value.sagemaker_image_version_arn
    }
  }
}