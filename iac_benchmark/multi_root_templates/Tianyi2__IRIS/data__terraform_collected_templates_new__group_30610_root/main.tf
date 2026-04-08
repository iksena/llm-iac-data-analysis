resource "aws_kinesis_firehose_delivery_stream" "this" {
  count       = var.create ? 1 : 0
  name        = var.name
  destination = var.destination
  tags        = var.tags

  dynamic "kinesis_source_configuration" {
    for_each = var.kinesis_source_stream_enabled ? [1] : []
    content {
      role_arn           = var.kinesis_source_configuration.role_arn
      kinesis_stream_arn = var.kinesis_source_configuration.kinesis_stream_arn
    }
  }
  dynamic "server_side_encryption" {
    for_each = var.server_side_encryption_enabled ? [1] : []
    content {
      key_type = var.server_side_encryption.key_type
      key_arn  = var.server_side_encryption.key_type == "CUSTOMER_MANAGED_CMK" ? var.server_side_encryption.key_arn : null
    }
  }

  ################################################################################
  # S3 Destination
  ################################################################################
  dynamic "extended_s3_configuration" {
    for_each = var.destination == "extended_s3" ? [1] : []
    content {
      bucket_arn          = var.s3_configuration.bucket_arn
      role_arn            = var.s3_configuration.role_arn
      prefix              = var.s3_configuration.prefix
      buffering_size      = var.s3_configuration.buffering_size
      buffering_interval  = var.s3_configuration.buffering_interval
      compression_format  = var.s3_configuration.compression_format
      error_output_prefix = var.s3_configuration.error_output_prefix
      kms_key_arn         = var.s3_configuration.kms_key_arn
      s3_backup_mode      = local.s3_backup_mode
      cloudwatch_logging_options {
        enabled         = var.destination_cw_log_enable
        log_group_name  = local.destination_cw_log_group_name
        log_stream_name = local.destination_cw_log_stream_name
      }
      dynamic "s3_backup_configuration" {
        for_each = var.s3_backup_enable ? [1] : []
        content {
          bucket_arn          = var.s3_backup_configuration.bucket_arn
          role_arn            = var.s3_backup_configuration.role_arn
          prefix              = var.s3_backup_configuration.prefix
          buffering_size      = var.s3_backup_configuration.buffering_size
          buffering_interval  = var.s3_backup_configuration.buffering_interval
          compression_format  = var.s3_backup_configuration.compression_format
          error_output_prefix = var.s3_backup_configuration.error_output_prefix
          kms_key_arn         = var.s3_backup_configuration.kms_key_arn
          cloudwatch_logging_options {
            enabled         = var.s3_backup_cw_log_enable
            log_group_name  = local.s3_backup_cw_log_group_name
            log_stream_name = local.s3_backup_cw_log_stream_name
          }
        }
      }
      dynamic "dynamic_partitioning_configuration" {
        for_each = var.dynamic_partitioning_enable ? [1] : []
        content {
          enabled        = true
          retry_duration = var.dynamic_partitioning_retry_duration
        }
      }
      dynamic "data_format_conversion_configuration" {
        for_each = var.extended_s3_data_format_conversion_enabled ? [1] : []
        content {
          enabled = true
          input_format_configuration {
            deserializer {
              dynamic "hive_json_ser_de" {
                for_each = var.data_format_conversion_input_format.deserializer == "hive_json_ser_de" ? [1] : []
                content {
                  timestamp_formats = var.data_format_conversion_input_format.hive_json_ser_de_timestamp_formats
                }
              }

              dynamic "open_x_json_ser_de" {
                for_each = var.data_format_conversion_input_format.deserializer == "open_x_json_ser_de" ? [1] : []
                content {
                  case_insensitive                         = var.data_format_conversion_input_format.open_x_json_ser_de_case_insensitive
                  column_to_json_key_mappings              = var.data_format_conversion_input_format.open_x_json_ser_de_column_to_json_key_mappings
                  convert_dots_in_json_keys_to_underscores = var.data_format_conversion_input_format.open_x_json_ser_de_convert_dots_in_json_keys_to_underscores
                }
              }
            }
          }
          output_format_configuration {
            serializer {
              dynamic "orc_ser_de" {
                for_each = var.data_format_conversion_output_format.serializer == "orc_ser_de" ? [1] : []
                content {
                  block_size_bytes                        = var.data_format_conversion_output_format.orc_ser_de_block_size_bytes
                  bloom_filter_columns                    = var.data_format_conversion_output_format.orc_ser_de_bloom_filter_columns
                  bloom_filter_false_positive_probability = var.data_format_conversion_output_format.orc_ser_de_bloom_filter_false_positive_probability
                  compression                             = var.data_format_conversion_output_format.orc_ser_de_compression
                  dictionary_key_threshold                = var.data_format_conversion_output_format.orc_ser_de_dictionary_key_threshold
                  enable_padding                          = var.data_format_conversion_output_format.orc_ser_de_enable_padding
                  format_version                          = var.data_format_conversion_output_format.orc_ser_de_format_version
                  padding_tolerance                       = var.data_format_conversion_output_format.orc_ser_de_padding_tolerance
                  row_index_stride                        = var.data_format_conversion_output_format.orc_ser_de_row_index_stride
                  stripe_size_bytes                       = var.data_format_conversion_output_format.orc_ser_de_stripe_size_bytes
                }
              }
              dynamic "parquet_ser_de" {
                for_each = var.data_format_conversion_output_format.serializer == "parquet_ser_de" ? [1] : []
                content {
                  block_size_bytes              = var.data_format_conversion_output_format.parquet_ser_de_block_size_bytes
                  compression                   = var.data_format_conversion_output_format.parquet_ser_de_compression
                  enable_dictionary_compression = var.data_format_conversion_output_format.parquet_ser_de_enable_dictionary_compression
                  max_padding_bytes             = var.data_format_conversion_output_format.parquet_ser_de_max_padding_bytes
                  page_size_bytes               = var.data_format_conversion_output_format.parquet_ser_de_page_size_bytes
                  writer_version                = var.data_format_conversion_output_format.parquet_ser_de_writer_version
                }
              }
            }
          }
          schema_configuration {
            database_name = var.data_format_conversion_schema_configuration.database_name
            role_arn      = var.data_format_conversion_schema_configuration.role_arn
            table_name    = var.data_format_conversion_schema_configuration.table_name
            catalog_id    = var.data_format_conversion_schema_configuration.catalog_id
            region        = var.data_format_conversion_schema_configuration.region
            version_id    = var.data_format_conversion_schema_configuration.version_id
          }
        }
      }
      dynamic "processing_configuration" {
        for_each = var.processing_configuration_enabled ? [1] : []
        content {
          enabled = true
          dynamic "processors" {
            for_each = var.processing_configuration_processors
            content {
              type = processors.value.type
              dynamic "parameters" {
                for_each = processors.value.parameters
                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }
    }
  }

  ################################################################################
  # Redshift Destination
  ################################################################################
  dynamic "redshift_configuration" {
    for_each = var.destination == "redshift" ? [1] : []
    content {
      cluster_jdbcurl = var.redshift_configuration.cluster_jdbcurl
      username        = var.redshift_configuration.username
      password        = var.redshift_configuration.password
      retry_duration  = var.redshift_configuration.retry_duration
      role_arn        = var.redshift_configuration.role_arn
      s3_configuration {
        bucket_arn         = var.s3_configuration.bucket_arn
        role_arn           = var.s3_configuration.role_arn
        prefix             = var.s3_configuration.prefix
        buffering_size     = var.s3_configuration.buffering_size
        buffering_interval = var.s3_configuration.buffering_interval
        compression_format = var.s3_configuration.compression_format
        kms_key_arn        = var.s3_configuration.kms_key_arn
        cloudwatch_logging_options {
          enabled         = var.destination_cw_log_enable
          log_group_name  = local.destination_cw_log_group_name
          log_stream_name = local.destination_cw_log_stream_name
        }
      }
      s3_backup_mode     = local.s3_backup_mode
      data_table_name    = var.redshift_configuration.data_table_name
      copy_options       = var.redshift_configuration.copy_options
      data_table_columns = var.redshift_configuration.data_table_columns
      cloudwatch_logging_options {
        enabled         = var.destination_cw_log_enable
        log_group_name  = local.destination_cw_log_group_name
        log_stream_name = local.destination_cw_log_stream_name
      }
      dynamic "s3_backup_configuration" {
        for_each = var.s3_backup_enable ? [1] : []
        content {
          bucket_arn          = var.s3_backup_configuration.bucket_arn
          role_arn            = var.s3_backup_configuration.role_arn
          prefix              = var.s3_backup_configuration.prefix
          buffering_size      = var.s3_backup_configuration.buffering_size
          buffering_interval  = var.s3_backup_configuration.buffering_interval
          compression_format  = var.s3_backup_configuration.compression_format
          error_output_prefix = var.s3_backup_configuration.error_output_prefix
          kms_key_arn         = var.s3_backup_configuration.kms_key_arn
          cloudwatch_logging_options {
            enabled         = var.s3_backup_cw_log_enable
            log_group_name  = local.s3_backup_cw_log_group_name
            log_stream_name = local.s3_backup_cw_log_stream_name
          }
        }
      }
      dynamic "processing_configuration" {
        for_each = var.processing_configuration_enabled ? [1] : []
        content {
          enabled = true
          dynamic "processors" {
            for_each = var.processing_configuration_processors
            content {
              type = processors.value.type
              dynamic "parameters" {
                for_each = processors.value.parameters
                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }
    }
  }

  ################################################################################
  # ElasticSearch Destination
  ################################################################################
  dynamic "elasticsearch_configuration" {
    for_each = var.destination == "elasticsearch" ? [1] : []
    content {
      buffering_interval    = var.elasticsearch_configuration.buffering_interval
      buffering_size        = var.elasticsearch_configuration.buffering_size
      domain_arn            = var.elasticsearch_configuration.domain_arn
      cluster_endpoint      = var.elasticsearch_configuration.cluster_endpoint
      index_name            = var.elasticsearch_configuration.index_name
      index_rotation_period = var.elasticsearch_configuration.index_rotation_period
      retry_duration        = var.elasticsearch_configuration.retry_duration
      role_arn              = var.elasticsearch_configuration.role_arn
      s3_backup_mode        = local.s3_backup_mode
      type_name             = var.elasticsearch_configuration.type_name
      s3_configuration {
        bucket_arn          = var.s3_configuration.bucket_arn
        role_arn            = var.s3_configuration.role_arn
        prefix              = var.s3_configuration.prefix
        buffering_size      = var.s3_configuration.buffering_size
        buffering_interval  = var.s3_configuration.buffering_interval
        compression_format  = var.s3_configuration.compression_format
        error_output_prefix = var.s3_configuration.error_output_prefix
        kms_key_arn         = var.s3_configuration.kms_key_arn
        cloudwatch_logging_options {
          enabled         = var.destination_cw_log_enable
          log_group_name  = local.destination_cw_log_group_name
          log_stream_name = local.destination_cw_log_stream_name
        }
      }
      cloudwatch_logging_options {
        enabled         = var.destination_cw_log_enable
        log_group_name  = local.destination_cw_log_group_name
        log_stream_name = local.destination_cw_log_stream_name
      }
      dynamic "vpc_config" {
        for_each = var.elasticsearch_configuration.vpc_config_enabled ? [1] : []
        content {
          role_arn           = var.elasticsearch_configuration.vpc_role_arn
          security_group_ids = var.elasticsearch_configuration.vpc_security_group_ids
          subnet_ids         = var.elasticsearch_configuration.vpc_subnet_ids
        }
      }
      dynamic "processing_configuration" {
        for_each = var.processing_configuration_enabled ? [1] : []
        content {
          enabled = true
          dynamic "processors" {
            for_each = var.processing_configuration_processors
            content {
              type = processors.value.type
              dynamic "parameters" {
                for_each = processors.value.parameters
                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }
    }
  }

  ################################################################################
  # OpenSearch Destination
  ################################################################################
  dynamic "opensearch_configuration" {
    for_each = var.destination == "opensearch" ? [1] : []
    content {
      buffering_interval    = var.opensearch_configuration.buffering_interval
      buffering_size        = var.opensearch_configuration.buffering_size
      domain_arn            = var.opensearch_configuration.domain_arn
      cluster_endpoint      = var.opensearch_configuration.cluster_endpoint
      index_name            = var.opensearch_configuration.index_name
      index_rotation_period = var.opensearch_configuration.index_rotation_period
      retry_duration        = var.opensearch_configuration.retry_duration
      role_arn              = var.opensearch_configuration.role_arn
      s3_backup_mode        = local.s3_backup_mode
      type_name             = var.opensearch_configuration.type_name
      s3_configuration {
        bucket_arn          = var.s3_configuration.bucket_arn
        role_arn            = var.s3_configuration.role_arn
        prefix              = var.s3_configuration.prefix
        buffering_size      = var.s3_configuration.buffering_size
        buffering_interval  = var.s3_configuration.buffering_interval
        compression_format  = var.s3_configuration.compression_format
        error_output_prefix = var.s3_configuration.error_output_prefix
        kms_key_arn         = var.s3_configuration.kms_key_arn
        cloudwatch_logging_options {
          enabled         = var.destination_cw_log_enable
          log_group_name  = local.destination_cw_log_group_name
          log_stream_name = local.destination_cw_log_stream_name
        }
      }
      cloudwatch_logging_options {
        enabled         = var.destination_cw_log_enable
        log_group_name  = local.destination_cw_log_group_name
        log_stream_name = local.destination_cw_log_stream_name
      }

      dynamic "vpc_config" {
        for_each = var.opensearch_configuration.vpc_config_enabled ? [1] : []
        content {
          role_arn           = var.opensearch_configuration.vpc_role_arn
          security_group_ids = var.opensearch_configuration.vpc_security_group_ids
          subnet_ids         = var.opensearch_configuration.vpc_subnet_ids
        }
      }
      dynamic "processing_configuration" {
        for_each = var.processing_configuration_enabled ? [1] : []
        content {
          enabled = true
          dynamic "processors" {
            for_each = var.processing_configuration_processors
            content {
              type = processors.value.type
              dynamic "parameters" {
                for_each = processors.value.parameters
                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }
    }
  }

  ################################################################################
  # Splunk Destination
  ################################################################################
  dynamic "splunk_configuration" {
    for_each = var.destination == "splunk" ? [1] : []
    content {
      hec_acknowledgment_timeout = var.splunk_configuration.hec_acknowledgment_timeout
      hec_endpoint               = var.splunk_configuration.hec_endpoint
      hec_endpoint_type          = var.splunk_configuration.hec_endpoint_type
      hec_token                  = var.splunk_configuration.hec_token
      retry_duration             = var.splunk_configuration.retry_duration
      s3_backup_mode             = local.s3_backup_mode
      s3_configuration {
        bucket_arn          = var.s3_configuration.bucket_arn
        role_arn            = var.s3_configuration.role_arn
        prefix              = var.s3_configuration.prefix
        buffering_size      = var.s3_configuration.buffering_size
        buffering_interval  = var.s3_configuration.buffering_interval
        compression_format  = var.s3_configuration.compression_format
        error_output_prefix = var.s3_configuration.error_output_prefix
        kms_key_arn         = var.s3_configuration.kms_key_arn
        cloudwatch_logging_options {
          enabled         = var.destination_cw_log_enable
          log_group_name  = local.destination_cw_log_group_name
          log_stream_name = local.destination_cw_log_stream_name
        }
      }
      cloudwatch_logging_options {
        enabled         = var.destination_cw_log_enable
        log_group_name  = local.destination_cw_log_group_name
        log_stream_name = local.destination_cw_log_stream_name
      }
      dynamic "processing_configuration" {
        for_each = var.processing_configuration_enabled ? [1] : []
        content {
          enabled = true
          dynamic "processors" {
            for_each = var.processing_configuration_processors
            content {
              type = processors.value.type
              dynamic "parameters" {
                for_each = processors.value.parameters
                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }
    }
  }

  ################################################################################
  # HTTP Endpoint Destination
  ################################################################################
  dynamic "http_endpoint_configuration" {
    for_each = var.destination == "http_endpoint" ? [1] : []
    content {
      url                = var.http_endpoint_configuration.url
      name               = var.http_endpoint_configuration.name
      access_key         = var.http_endpoint_configuration.access_key
      role_arn           = var.http_endpoint_configuration.role_arn
      s3_backup_mode     = local.s3_backup_mode
      buffering_size     = var.http_endpoint_configuration.buffering_size
      buffering_interval = var.http_endpoint_configuration.buffering_interval
      retry_duration     = var.http_endpoint_configuration.retry_duration
      s3_configuration {
        bucket_arn          = var.s3_configuration.bucket_arn
        role_arn            = var.s3_configuration.role_arn
        prefix              = var.s3_configuration.prefix
        buffering_size      = var.s3_configuration.buffering_size
        buffering_interval  = var.s3_configuration.buffering_interval
        compression_format  = var.s3_configuration.compression_format
        error_output_prefix = var.s3_configuration.error_output_prefix
        kms_key_arn         = var.s3_configuration.kms_key_arn
        cloudwatch_logging_options {
          enabled         = var.destination_cw_log_enable
          log_group_name  = local.destination_cw_log_group_name
          log_stream_name = local.destination_cw_log_stream_name
        }
      }
      cloudwatch_logging_options {
        enabled         = var.destination_cw_log_enable
        log_group_name  = local.destination_cw_log_group_name
        log_stream_name = local.destination_cw_log_stream_name
      }
      dynamic "processing_configuration" {
        for_each = var.processing_configuration_enabled ? [1] : []
        content {
          enabled = true
          dynamic "processors" {
            for_each = var.processing_configuration_processors
            content {
              type = processors.value.type
              dynamic "parameters" {
                for_each = processors.value.parameters
                content {
                  parameter_name  = parameters.value.parameter_name
                  parameter_value = parameters.value.parameter_value
                }
              }
            }
          }
        }
      }
      dynamic "request_configuration" {
        for_each = var.http_endpoint_configuration.request_configuration_enabled ? [1] : []
        content {
          content_encoding = var.http_endpoint_configuration.request_configuration_content_encoding

          dynamic "common_attributes" {
            for_each = var.http_endpoint_configuration.request_configuration_common_attributes
            content {
              name  = common_attributes.value.name
              value = common_attributes.value.value
            }
          }
        }
      }
    }
  }
}
