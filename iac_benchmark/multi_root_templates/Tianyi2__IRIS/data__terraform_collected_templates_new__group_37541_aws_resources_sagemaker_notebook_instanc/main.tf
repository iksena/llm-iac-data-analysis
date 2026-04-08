resource "aws_sagemaker_notebook_instance" "this" {
  name          = var.name
  role_arn      = var.role_arn
  instance_type = var.instance_type

  region                       = var.region
  platform_identifier          = var.platform_identifier
  volume_size                  = var.volume_size
  subnet_id                    = var.subnet_id
  security_groups              = var.security_groups
  additional_code_repositories = var.additional_code_repositories
  default_code_repository      = var.default_code_repository
  direct_internet_access       = var.direct_internet_access
  kms_key_id                   = var.kms_key_id
  lifecycle_config_name        = var.lifecycle_config_name
  root_access                  = var.root_access
  tags                         = var.tags

  dynamic "instance_metadata_service_configuration" {
    for_each = var.instance_metadata_service_configuration != null ? [var.instance_metadata_service_configuration] : []
    content {
      minimum_instance_metadata_service_version = instance_metadata_service_configuration.value.minimum_instance_metadata_service_version
    }
  }
}