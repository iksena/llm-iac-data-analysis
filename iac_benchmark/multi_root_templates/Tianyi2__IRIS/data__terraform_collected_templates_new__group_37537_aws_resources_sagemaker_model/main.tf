resource "aws_sagemaker_model" "this" {
  name                     = var.name
  region                   = var.region
  execution_role_arn       = var.execution_role_arn
  enable_network_isolation = var.enable_network_isolation
  tags                     = var.tags

  dynamic "primary_container" {
    for_each = var.primary_container != null ? [var.primary_container] : []
    content {
      image                        = primary_container.value.image
      mode                         = primary_container.value.mode
      model_data_url               = primary_container.value.model_data_url
      model_package_name           = primary_container.value.model_package_name
      container_hostname           = primary_container.value.container_hostname
      environment                  = primary_container.value.environment
      inference_specification_name = primary_container.value.inference_specification_name

      dynamic "model_data_source" {
        for_each = primary_container.value.model_data_source != null ? [primary_container.value.model_data_source] : []
        content {
          dynamic "s3_data_source" {
            for_each = [model_data_source.value.s3_data_source]
            content {
              compression_type = s3_data_source.value.compression_type
              s3_data_type     = s3_data_source.value.s3_data_type
              s3_uri           = s3_data_source.value.s3_uri

              dynamic "model_access_config" {
                for_each = s3_data_source.value.model_access_config != null ? [s3_data_source.value.model_access_config] : []
                content {
                  accept_eula = model_access_config.value.accept_eula
                }
              }
            }
          }
        }
      }

      dynamic "image_config" {
        for_each = primary_container.value.image_config != null ? [primary_container.value.image_config] : []
        content {
          repository_access_mode = image_config.value.repository_access_mode

          dynamic "repository_auth_config" {
            for_each = image_config.value.repository_auth_config != null ? [image_config.value.repository_auth_config] : []
            content {
              repository_credentials_provider_arn = repository_auth_config.value.repository_credentials_provider_arn
            }
          }
        }
      }

      dynamic "multi_model_config" {
        for_each = primary_container.value.multi_model_config != null ? [primary_container.value.multi_model_config] : []
        content {
          model_cache_setting = multi_model_config.value.model_cache_setting
        }
      }
    }
  }

  dynamic "container" {
    for_each = var.container != null ? var.container : []
    content {
      image                        = container.value.image
      mode                         = container.value.mode
      model_data_url               = container.value.model_data_url
      model_package_name           = container.value.model_package_name
      container_hostname           = container.value.container_hostname
      environment                  = container.value.environment
      inference_specification_name = container.value.inference_specification_name

      dynamic "model_data_source" {
        for_each = container.value.model_data_source != null ? [container.value.model_data_source] : []
        content {
          dynamic "s3_data_source" {
            for_each = [model_data_source.value.s3_data_source]
            content {
              compression_type = s3_data_source.value.compression_type
              s3_data_type     = s3_data_source.value.s3_data_type
              s3_uri           = s3_data_source.value.s3_uri

              dynamic "model_access_config" {
                for_each = s3_data_source.value.model_access_config != null ? [s3_data_source.value.model_access_config] : []
                content {
                  accept_eula = model_access_config.value.accept_eula
                }
              }
            }
          }
        }
      }

      dynamic "image_config" {
        for_each = container.value.image_config != null ? [container.value.image_config] : []
        content {
          repository_access_mode = image_config.value.repository_access_mode

          dynamic "repository_auth_config" {
            for_each = image_config.value.repository_auth_config != null ? [image_config.value.repository_auth_config] : []
            content {
              repository_credentials_provider_arn = repository_auth_config.value.repository_credentials_provider_arn
            }
          }
        }
      }

      dynamic "multi_model_config" {
        for_each = container.value.multi_model_config != null ? [container.value.multi_model_config] : []
        content {
          model_cache_setting = multi_model_config.value.model_cache_setting
        }
      }
    }
  }

  dynamic "inference_execution_config" {
    for_each = var.inference_execution_config != null ? [var.inference_execution_config] : []
    content {
      mode = inference_execution_config.value.mode
    }
  }

  dynamic "vpc_config" {
    for_each = var.vpc_config != null ? [var.vpc_config] : []
    content {
      security_group_ids = vpc_config.value.security_group_ids
      subnets            = vpc_config.value.subnets
    }
  }
}