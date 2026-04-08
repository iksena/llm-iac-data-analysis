resource "aws_sagemaker_feature_group" "this" {
  region                         = var.region
  feature_group_name             = var.feature_group_name
  record_identifier_feature_name = var.record_identifier_feature_name
  event_time_feature_name        = var.event_time_feature_name
  description                    = var.description
  role_arn                       = var.role_arn

  dynamic "feature_definition" {
    for_each = var.feature_definition
    content {
      feature_name = feature_definition.value.feature_name
      feature_type = feature_definition.value.feature_type
    }
  }

  dynamic "offline_store_config" {
    for_each = var.offline_store_config != null ? [var.offline_store_config] : []
    content {
      disable_glue_table_creation = offline_store_config.value.disable_glue_table_creation
      table_format                = offline_store_config.value.table_format

      s3_storage_config {
        kms_key_id             = offline_store_config.value.s3_storage_config.kms_key_id
        s3_uri                 = offline_store_config.value.s3_storage_config.s3_uri
        resolved_output_s3_uri = offline_store_config.value.s3_storage_config.resolved_output_s3_uri
      }

      dynamic "data_catalog_config" {
        for_each = offline_store_config.value.data_catalog_config != null ? [offline_store_config.value.data_catalog_config] : []
        content {
          catalog    = data_catalog_config.value.catalog
          database   = data_catalog_config.value.database
          table_name = data_catalog_config.value.table_name
        }
      }
    }
  }

  dynamic "online_store_config" {
    for_each = var.online_store_config != null ? [var.online_store_config] : []
    content {
      enable_online_store = online_store_config.value.enable_online_store
      storage_type        = online_store_config.value.storage_type

      dynamic "security_config" {
        for_each = online_store_config.value.security_config != null ? [online_store_config.value.security_config] : []
        content {
          kms_key_id = security_config.value.kms_key_id
        }
      }

      dynamic "ttl_duration" {
        for_each = online_store_config.value.ttl_duration != null ? [online_store_config.value.ttl_duration] : []
        content {
          unit  = ttl_duration.value.unit
          value = ttl_duration.value.value
        }
      }
    }
  }

  tags = var.tags
}