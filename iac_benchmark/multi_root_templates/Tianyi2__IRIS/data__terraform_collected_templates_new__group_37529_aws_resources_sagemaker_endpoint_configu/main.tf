resource "aws_sagemaker_endpoint_configuration" "this" {
  region      = var.region
  name        = var.name
  name_prefix = var.name_prefix
  kms_key_arn = var.kms_key_arn
  tags        = var.tags

  dynamic "production_variants" {
    for_each = var.production_variants
    content {
      accelerator_type                                  = production_variants.value.accelerator_type
      container_startup_health_check_timeout_in_seconds = production_variants.value.container_startup_health_check_timeout_in_seconds
      enable_ssm_access                                 = production_variants.value.enable_ssm_access
      inference_ami_version                             = production_variants.value.inference_ami_version
      initial_instance_count                            = production_variants.value.initial_instance_count
      instance_type                                     = production_variants.value.instance_type
      initial_variant_weight                            = production_variants.value.initial_variant_weight
      model_data_download_timeout_in_seconds            = production_variants.value.model_data_download_timeout_in_seconds
      model_name                                        = production_variants.value.model_name
      variant_name                                      = production_variants.value.variant_name
      volume_size_in_gb                                 = production_variants.value.volume_size_in_gb

      dynamic "core_dump_config" {
        for_each = production_variants.value.core_dump_config != null ? [production_variants.value.core_dump_config] : []
        content {
          destination_s3_uri = core_dump_config.value.destination_s3_uri
          kms_key_id         = core_dump_config.value.kms_key_id
        }
      }

      dynamic "routing_config" {
        for_each = production_variants.value.routing_config != null ? [production_variants.value.routing_config] : []
        content {
          routing_strategy = routing_config.value.routing_strategy
        }
      }

      dynamic "serverless_config" {
        for_each = production_variants.value.serverless_config != null ? [production_variants.value.serverless_config] : []
        content {
          max_concurrency         = serverless_config.value.max_concurrency
          memory_size_in_mb       = serverless_config.value.memory_size_in_mb
          provisioned_concurrency = serverless_config.value.provisioned_concurrency
        }
      }

      dynamic "managed_instance_scaling" {
        for_each = production_variants.value.managed_instance_scaling != null ? [production_variants.value.managed_instance_scaling] : []
        content {
          status             = managed_instance_scaling.value.status
          min_instance_count = managed_instance_scaling.value.min_instance_count
          max_instance_count = managed_instance_scaling.value.max_instance_count
        }
      }
    }
  }

  dynamic "shadow_production_variants" {
    for_each = var.shadow_production_variants
    content {
      accelerator_type                                  = shadow_production_variants.value.accelerator_type
      container_startup_health_check_timeout_in_seconds = shadow_production_variants.value.container_startup_health_check_timeout_in_seconds
      enable_ssm_access                                 = shadow_production_variants.value.enable_ssm_access
      inference_ami_version                             = shadow_production_variants.value.inference_ami_version
      initial_instance_count                            = shadow_production_variants.value.initial_instance_count
      instance_type                                     = shadow_production_variants.value.instance_type
      initial_variant_weight                            = shadow_production_variants.value.initial_variant_weight
      model_data_download_timeout_in_seconds            = shadow_production_variants.value.model_data_download_timeout_in_seconds
      model_name                                        = shadow_production_variants.value.model_name
      variant_name                                      = shadow_production_variants.value.variant_name
      volume_size_in_gb                                 = shadow_production_variants.value.volume_size_in_gb

      dynamic "core_dump_config" {
        for_each = shadow_production_variants.value.core_dump_config != null ? [shadow_production_variants.value.core_dump_config] : []
        content {
          destination_s3_uri = core_dump_config.value.destination_s3_uri
          kms_key_id         = core_dump_config.value.kms_key_id
        }
      }

      dynamic "routing_config" {
        for_each = shadow_production_variants.value.routing_config != null ? [shadow_production_variants.value.routing_config] : []
        content {
          routing_strategy = routing_config.value.routing_strategy
        }
      }

      dynamic "serverless_config" {
        for_each = shadow_production_variants.value.serverless_config != null ? [shadow_production_variants.value.serverless_config] : []
        content {
          max_concurrency         = serverless_config.value.max_concurrency
          memory_size_in_mb       = serverless_config.value.memory_size_in_mb
          provisioned_concurrency = serverless_config.value.provisioned_concurrency
        }
      }

      dynamic "managed_instance_scaling" {
        for_each = shadow_production_variants.value.managed_instance_scaling != null ? [shadow_production_variants.value.managed_instance_scaling] : []
        content {
          status             = managed_instance_scaling.value.status
          min_instance_count = managed_instance_scaling.value.min_instance_count
          max_instance_count = managed_instance_scaling.value.max_instance_count
        }
      }
    }
  }

  dynamic "data_capture_config" {
    for_each = var.data_capture_config != null ? [var.data_capture_config] : []
    content {
      initial_sampling_percentage = data_capture_config.value.initial_sampling_percentage
      destination_s3_uri          = data_capture_config.value.destination_s3_uri
      kms_key_id                  = data_capture_config.value.kms_key_id
      enable_capture              = data_capture_config.value.enable_capture

      dynamic "capture_options" {
        for_each = data_capture_config.value.capture_options
        content {
          capture_mode = capture_options.value.capture_mode
        }
      }

      dynamic "capture_content_type_header" {
        for_each = data_capture_config.value.capture_content_type_header != null ? [data_capture_config.value.capture_content_type_header] : []
        content {
          csv_content_types  = capture_content_type_header.value.csv_content_types
          json_content_types = capture_content_type_header.value.json_content_types
        }
      }
    }
  }

  dynamic "async_inference_config" {
    for_each = var.async_inference_config != null ? [var.async_inference_config] : []
    content {
      dynamic "output_config" {
        for_each = [async_inference_config.value.output_config]
        content {
          s3_output_path  = output_config.value.s3_output_path
          s3_failure_path = output_config.value.s3_failure_path
          kms_key_id      = output_config.value.kms_key_id

          dynamic "notification_config" {
            for_each = output_config.value.notification_config != null ? [output_config.value.notification_config] : []
            content {
              include_inference_response_in = notification_config.value.include_inference_response_in
              error_topic                   = notification_config.value.error_topic
              success_topic                 = notification_config.value.success_topic
            }
          }
        }
      }

      dynamic "client_config" {
        for_each = async_inference_config.value.client_config != null ? [async_inference_config.value.client_config] : []
        content {
          max_concurrent_invocations_per_instance = client_config.value.max_concurrent_invocations_per_instance
        }
      }
    }
  }
}