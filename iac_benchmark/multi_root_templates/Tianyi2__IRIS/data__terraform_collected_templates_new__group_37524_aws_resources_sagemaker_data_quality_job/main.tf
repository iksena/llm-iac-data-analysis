resource "aws_sagemaker_data_quality_job_definition" "this" {
  region   = var.region
  name     = var.name
  role_arn = var.role_arn
  tags     = var.tags

  dynamic "data_quality_app_specification" {
    for_each = var.data_quality_app_specification != null ? [var.data_quality_app_specification] : []
    content {
      image_uri                           = data_quality_app_specification.value.image_uri
      post_analytics_processor_source_uri = try(data_quality_app_specification.value.post_analytics_processor_source_uri, null)
      record_preprocessor_source_uri      = try(data_quality_app_specification.value.record_preprocessor_source_uri, null)
    }
  }

  dynamic "data_quality_baseline_config" {
    for_each = var.data_quality_baseline_config != null ? [var.data_quality_baseline_config] : []
    content {
      constraints_resource {
        s3_uri = data_quality_baseline_config.value.constraints_resource.s3_uri
      }

      statistics_resource {
        s3_uri = data_quality_baseline_config.value.statistics_resource.s3_uri
      }
    }
  }

  data_quality_job_input {
    batch_transform_input {
      data_captured_destination_s3_uri = var.data_quality_job_input.batch_transform_input.data_captured_destination_s3_uri
      dataset_format {
        csv {
          header = var.data_quality_job_input.batch_transform_input.dataset_format.csv.header
        }
      }
      local_path                = var.data_quality_job_input.batch_transform_input.local_path
      s3_data_distribution_type = var.data_quality_job_input.batch_transform_input.s3_data_distribution_type
      s3_input_mode             = var.data_quality_job_input.batch_transform_input.s3_input_mode
    }
  }

  data_quality_job_output_config {
    kms_key_id = var.data_quality_job_output_config.kms_key_id

    dynamic "monitoring_outputs" {
      for_each = try(var.data_quality_job_output_config.monitoring_outputs, [])
      content {
        s3_output {
          local_path     = monitoring_outputs.value.s3_output.local_path
          s3_upload_mode = monitoring_outputs.value.s3_output.s3_upload_mode
          s3_uri         = monitoring_outputs.value.s3_output.s3_uri
        }
      }
    }
  }

  job_resources {
    cluster_config {
      instance_count    = var.job_resources.cluster_config.instance_count
      instance_type     = var.job_resources.cluster_config.instance_type
      volume_kms_key_id = var.job_resources.cluster_config.volume_kms_key_id
      volume_size_in_gb = var.job_resources.cluster_config.volume_size_in_gb
    }
  }

  dynamic "network_config" {
    for_each = var.network_config != null ? [var.network_config] : []
    content {
      enable_inter_container_traffic_encryption = network_config.value.enable_inter_container_traffic_encryption
      enable_network_isolation                  = network_config.value.enable_network_isolation

      dynamic "vpc_config" {
        for_each = network_config.value.vpc_config != null ? [network_config.value.vpc_config] : []
        content {
          security_group_ids = vpc_config.value.security_group_ids
          subnets            = vpc_config.value.subnets
        }
      }
    }
  }

  dynamic "stopping_condition" {
    for_each = var.stopping_condition != null ? [var.stopping_condition] : []
    content {
      max_runtime_in_seconds = stopping_condition.value.max_runtime_in_seconds
    }
  }
}