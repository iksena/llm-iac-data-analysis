variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
  validation {
    condition     = var.region == null || can(regex("^[a-z0-9-]+$", var.region))
    error_message = "resource_aws_kinesis_firehose_delivery_stream, region must be a valid AWS region identifier."
  }
}

variable "name" {
  description = "A name to identify the stream. This is unique to the AWS account and region the Stream is created in. When using for WAF logging, name must be prefixed with `aws-waf-logs-`."
  type        = string
  validation {
    condition     = can(regex("^[a-zA-Z0-9._-]+$", var.name))
    error_message = "resource_aws_kinesis_firehose_delivery_stream, name must contain only alphanumeric characters, periods, underscores, and hyphens."
  }
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "kinesis_source_configuration" {
  description = "The stream and role Amazon Resource Names (ARNs) for a Kinesis data stream used as the source for a delivery stream."
  type = object({
    kinesis_stream_arn = string
    role_arn           = string
  })
  default = null
  validation {
    condition = var.kinesis_source_configuration == null || (
      can(regex("^arn:aws:kinesis:", var.kinesis_source_configuration.kinesis_stream_arn)) &&
      can(regex("^arn:aws:iam:", var.kinesis_source_configuration.role_arn))
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, kinesis_source_configuration must have valid ARN format for kinesis_stream_arn and role_arn."
  }
}

variable "msk_source_configuration" {
  description = "The configuration for the Amazon MSK cluster to be used as the source for a delivery stream."
  type = object({
    authentication_configuration = object({
      connectivity = string
      role_arn     = string
    })
    msk_cluster_arn     = string
    topic_name          = string
    read_from_timestamp = optional(string)
  })
  default = null
  validation {
    condition = var.msk_source_configuration == null || (
      contains(["PUBLIC", "PRIVATE"], var.msk_source_configuration.authentication_configuration.connectivity) &&
      can(regex("^arn:aws:iam:", var.msk_source_configuration.authentication_configuration.role_arn)) &&
      can(regex("^arn:aws:kafka:", var.msk_source_configuration.msk_cluster_arn))
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, msk_source_configuration connectivity must be PUBLIC or PRIVATE, and ARNs must be valid."
  }
}

variable "server_side_encryption" {
  description = "Encrypt at rest options."
  type = object({
    enabled  = optional(bool, false)
    key_type = optional(string, "AWS_OWNED_CMK")
    key_arn  = optional(string)
  })
  default = null
  validation {
    condition = var.server_side_encryption == null || (
      contains(["AWS_OWNED_CMK", "CUSTOMER_MANAGED_CMK"], var.server_side_encryption.key_type) &&
      (var.server_side_encryption.key_type != "CUSTOMER_MANAGED_CMK" || var.server_side_encryption.key_arn != null)
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, server_side_encryption key_type must be AWS_OWNED_CMK or CUSTOMER_MANAGED_CMK, and key_arn is required when using CUSTOMER_MANAGED_CMK."
  }
}

variable "destination" {
  description = "This is the destination to where the data is delivered."
  type        = string
  validation {
    condition = contains([
      "s3", "extended_s3", "redshift", "elasticsearch", "splunk",
      "http_endpoint", "opensearch", "opensearchserverless", "snowflake", "iceberg"
    ], var.destination)
    error_message = "resource_aws_kinesis_firehose_delivery_stream, destination must be one of: s3, extended_s3, redshift, elasticsearch, splunk, http_endpoint, opensearch, opensearchserverless, snowflake, or iceberg."
  }
}

variable "elasticsearch_configuration" {
  description = "Configuration options when destination is elasticsearch."
  type = object({
    buffering_interval    = optional(number, 300)
    buffering_size        = optional(number, 5)
    domain_arn            = optional(string)
    cluster_endpoint      = optional(string)
    index_name            = string
    index_rotation_period = optional(string, "OneDay")
    retry_duration        = optional(number, 300)
    role_arn              = string
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
    s3_backup_mode = optional(string, "FailedDocumentsOnly")
    type_name      = optional(string)
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    vpc_config = optional(object({
      subnet_ids         = list(string)
      security_group_ids = list(string)
      role_arn           = string
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
  })
  default = null
  validation {
    condition = var.elasticsearch_configuration == null || (
      can(regex("^arn:aws:iam:", var.elasticsearch_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.elasticsearch_configuration.s3_configuration.bucket_arn)) &&
      var.elasticsearch_configuration.buffering_interval >= 0 && var.elasticsearch_configuration.buffering_interval <= 900 &&
      var.elasticsearch_configuration.buffering_size >= 1 && var.elasticsearch_configuration.buffering_size <= 100 &&
      contains(["NoRotation", "OneHour", "OneDay", "OneWeek", "OneMonth"], var.elasticsearch_configuration.index_rotation_period) &&
      var.elasticsearch_configuration.retry_duration >= 0 && var.elasticsearch_configuration.retry_duration <= 7200 &&
      contains(["FailedDocumentsOnly", "AllDocuments"], var.elasticsearch_configuration.s3_backup_mode) &&
      (var.elasticsearch_configuration.domain_arn == null || var.elasticsearch_configuration.cluster_endpoint == null) &&
      (var.elasticsearch_configuration.domain_arn != null || var.elasticsearch_configuration.cluster_endpoint != null)
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, elasticsearch_configuration must have valid ARNs, buffering values within limits, valid rotation period and backup mode, and either domain_arn or cluster_endpoint (but not both)."
  }
}

variable "extended_s3_configuration" {
  description = "Enhanced configuration options for the s3 destination. Required when destination is extended_s3."
  type = object({
    role_arn            = string
    bucket_arn          = string
    prefix              = optional(string)
    buffering_size      = optional(number, 5)
    buffering_interval  = optional(number, 300)
    compression_format  = optional(string, "UNCOMPRESSED")
    error_output_prefix = optional(string)
    kms_key_arn         = optional(string)
    custom_time_zone    = optional(string, "UTC")
    file_extension      = optional(string)
    s3_backup_mode      = optional(string, "Disabled")
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    s3_backup_configuration = optional(object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    }))
    data_format_conversion_configuration = optional(object({
      enabled = optional(bool, true)
      input_format_configuration = object({
        deserializer = object({
          hive_json_ser_de = optional(object({
            timestamp_formats = optional(list(string))
          }))
          open_x_json_ser_de = optional(object({
            case_insensitive                         = optional(bool, true)
            column_to_json_key_mappings              = optional(map(string))
            convert_dots_in_json_keys_to_underscores = optional(bool, false)
          }))
        })
      })
      output_format_configuration = object({
        serializer = object({
          orc_ser_de = optional(object({
            block_size_bytes                        = optional(number)
            bloom_filter_columns                    = optional(list(string))
            bloom_filter_false_positive_probability = optional(number, 0.05)
            compression                             = optional(string, "SNAPPY")
            dictionary_key_threshold                = optional(number)
            enable_padding                          = optional(bool, false)
            format_version                          = optional(string, "V0_12")
            padding_tolerance                       = optional(number, 0.05)
            row_index_stride                        = optional(number, 10000)
            stripe_size_bytes                       = optional(number)
          }))
          parquet_ser_de = optional(object({
            block_size_bytes              = optional(number)
            compression                   = optional(string, "SNAPPY")
            enable_dictionary_compression = optional(bool)
            max_padding_bytes             = optional(number, 0)
            page_size_bytes               = optional(number)
            writer_version                = optional(string, "V1")
          }))
        })
      })
      schema_configuration = object({
        database_name = string
        role_arn      = string
        table_name    = string
        catalog_id    = optional(string)
        region        = optional(string)
        version_id    = optional(string, "LATEST")
      })
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
    dynamic_partitioning_configuration = optional(object({
      enabled        = optional(bool, false)
      retry_duration = optional(number, 300)
    }))
  })
  default = null
  validation {
    condition = var.extended_s3_configuration == null || (
      can(regex("^arn:aws:iam:", var.extended_s3_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.extended_s3_configuration.bucket_arn)) &&
      contains(["UNCOMPRESSED", "GZIP", "ZIP", "Snappy", "HADOOP_SNAPPY"], var.extended_s3_configuration.compression_format) &&
      contains(["Disabled", "Enabled"], var.extended_s3_configuration.s3_backup_mode) &&
      (var.extended_s3_configuration.custom_time_zone == "UTC" || can(regex("^[A-Z][a-z_]+/[A-Z][a-z_]+$", var.extended_s3_configuration.custom_time_zone)))
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, extended_s3_configuration must have valid ARNs, compression format, backup mode, and time zone."
  }
}

variable "http_endpoint_configuration" {
  description = "Configuration options when destination is http_endpoint."
  type = object({
    url        = string
    name       = optional(string)
    access_key = optional(string)
    role_arn   = string
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
    s3_backup_mode     = optional(string, "FailedDataOnly")
    buffering_size     = optional(number, 5)
    buffering_interval = optional(number, 300)
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
    request_configuration = optional(object({
      content_encoding = optional(string, "NONE")
      common_attributes = optional(list(object({
        name  = string
        value = string
      })))
    }))
    retry_duration = optional(number, 300)
    secrets_manager_configuration = optional(object({
      enabled    = optional(bool)
      secret_arn = optional(string)
      role_arn   = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.http_endpoint_configuration == null || (
      can(regex("^https?://", var.http_endpoint_configuration.url)) &&
      can(regex("^arn:aws:iam:", var.http_endpoint_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.http_endpoint_configuration.s3_configuration.bucket_arn)) &&
      contains(["FailedDataOnly", "AllData"], var.http_endpoint_configuration.s3_backup_mode) &&
      var.http_endpoint_configuration.retry_duration >= 0 && var.http_endpoint_configuration.retry_duration <= 7200 &&
      contains(["NONE", "GZIP"], var.http_endpoint_configuration.request_configuration.content_encoding)
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, http_endpoint_configuration must have valid URL, ARNs, backup mode, retry duration, and content encoding."
  }
}

variable "iceberg_configuration" {
  description = "Configuration options when destination is iceberg."
  type = object({
    buffering_interval = optional(number, 300)
    buffering_size     = optional(number, 5)
    catalog_arn        = string
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    destination_table_configuration = optional(object({
      database_name          = string
      table_name             = string
      s3_error_output_prefix = optional(string)
      unique_keys            = optional(list(string))
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
    role_arn       = string
    retry_duration = optional(number)
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
  })
  default = null
  validation {
    condition = var.iceberg_configuration == null || (
      can(regex("^arn:aws:glue:", var.iceberg_configuration.catalog_arn)) &&
      can(regex("^arn:aws:iam:", var.iceberg_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.iceberg_configuration.s3_configuration.bucket_arn)) &&
      var.iceberg_configuration.buffering_interval >= 0 && var.iceberg_configuration.buffering_interval <= 900 &&
      var.iceberg_configuration.buffering_size >= 1 && var.iceberg_configuration.buffering_size <= 128 &&
      (var.iceberg_configuration.retry_duration == null || (var.iceberg_configuration.retry_duration >= 0 && var.iceberg_configuration.retry_duration <= 7200))
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, iceberg_configuration must have valid ARNs and buffering values within limits."
  }
}

variable "opensearch_configuration" {
  description = "Configuration options when destination is opensearch."
  type = object({
    buffering_interval    = optional(number, 300)
    buffering_size        = optional(number, 5)
    domain_arn            = optional(string)
    cluster_endpoint      = optional(string)
    index_name            = string
    index_rotation_period = optional(string, "OneDay")
    retry_duration        = optional(number, 300)
    role_arn              = string
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
    s3_backup_mode = optional(string, "FailedDocumentsOnly")
    type_name      = optional(string)
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    vpc_config = optional(object({
      subnet_ids         = list(string)
      security_group_ids = list(string)
      role_arn           = string
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
    document_id_options = optional(object({
      default_document_id_format = string
    }))
  })
  default = null
  validation {
    condition = var.opensearch_configuration == null || (
      can(regex("^arn:aws:iam:", var.opensearch_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.opensearch_configuration.s3_configuration.bucket_arn)) &&
      var.opensearch_configuration.buffering_interval >= 0 && var.opensearch_configuration.buffering_interval <= 900 &&
      var.opensearch_configuration.buffering_size >= 1 && var.opensearch_configuration.buffering_size <= 100 &&
      contains(["NoRotation", "OneHour", "OneDay", "OneWeek", "OneMonth"], var.opensearch_configuration.index_rotation_period) &&
      var.opensearch_configuration.retry_duration >= 0 && var.opensearch_configuration.retry_duration <= 7200 &&
      contains(["FailedDocumentsOnly", "AllDocuments"], var.opensearch_configuration.s3_backup_mode) &&
      (var.opensearch_configuration.domain_arn == null || var.opensearch_configuration.cluster_endpoint == null) &&
      (var.opensearch_configuration.domain_arn != null || var.opensearch_configuration.cluster_endpoint != null) &&
      (var.opensearch_configuration.document_id_options == null || contains(["FIREHOSE_DEFAULT", "NO_DOCUMENT_ID"], var.opensearch_configuration.document_id_options.default_document_id_format))
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, opensearch_configuration must have valid ARNs, buffering values within limits, valid rotation period and backup mode, either domain_arn or cluster_endpoint (but not both), and valid document_id_format."
  }
}

variable "opensearchserverless_configuration" {
  description = "Configuration options when destination is opensearchserverless."
  type = object({
    buffering_interval  = optional(number, 300)
    buffering_size      = optional(number, 5)
    collection_endpoint = string
    index_name          = string
    retry_duration      = optional(number, 300)
    role_arn            = string
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
    s3_backup_mode = optional(string, "FailedDocumentsOnly")
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    vpc_config = optional(object({
      subnet_ids         = list(string)
      security_group_ids = list(string)
      role_arn           = string
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
  })
  default = null
  validation {
    condition = var.opensearchserverless_configuration == null || (
      can(regex("^arn:aws:iam:", var.opensearchserverless_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.opensearchserverless_configuration.s3_configuration.bucket_arn)) &&
      var.opensearchserverless_configuration.buffering_interval >= 0 && var.opensearchserverless_configuration.buffering_interval <= 900 &&
      var.opensearchserverless_configuration.buffering_size >= 1 && var.opensearchserverless_configuration.buffering_size <= 100 &&
      var.opensearchserverless_configuration.retry_duration >= 0 && var.opensearchserverless_configuration.retry_duration <= 7200 &&
      contains(["FailedDocumentsOnly", "AllDocuments"], var.opensearchserverless_configuration.s3_backup_mode)
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, opensearchserverless_configuration must have valid ARNs, buffering values within limits, valid retry duration, and backup mode."
  }
}

variable "redshift_configuration" {
  description = "Configuration options when destination is redshift."
  type = object({
    cluster_jdbcurl = string
    username        = optional(string)
    password        = optional(string)
    retry_duration  = optional(number, 3600)
    role_arn        = string
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
    s3_backup_mode = optional(string, "Disabled")
    s3_backup_configuration = optional(object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    }))
    secrets_manager_configuration = optional(object({
      enabled    = optional(bool)
      secret_arn = optional(string)
      role_arn   = optional(string)
    }))
    data_table_name    = string
    copy_options       = optional(string)
    data_table_columns = optional(string)
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
  })
  default = null
  validation {
    condition = var.redshift_configuration == null || (
      can(regex("^jdbc:redshift:", var.redshift_configuration.cluster_jdbcurl)) &&
      can(regex("^arn:aws:iam:", var.redshift_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.redshift_configuration.s3_configuration.bucket_arn)) &&
      contains(["Disabled", "Enabled"], var.redshift_configuration.s3_backup_mode) &&
      (var.redshift_configuration.username != null || var.redshift_configuration.secrets_manager_configuration != null) &&
      (var.redshift_configuration.password != null || var.redshift_configuration.secrets_manager_configuration != null)
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, redshift_configuration must have valid JDBC URL, ARNs, backup mode, and either username/password or secrets_manager_configuration."
  }
}

variable "snowflake_configuration" {
  description = "Configuration options when destination is snowflake."
  type = object({
    account_url        = string
    buffering_size     = optional(number, 1)
    buffering_interval = optional(number, 0)
    private_key        = optional(string)
    key_passphrase     = optional(string)
    user               = optional(string)
    database           = string
    schema             = string
    table              = string
    snowflake_role_configuration = optional(object({
      enabled        = optional(bool)
      snowflake_role = optional(string)
    }))
    data_loading_option  = optional(string)
    metadata_column_name = optional(string)
    content_column_name  = optional(string)
    snowflake_vpc_configuration = optional(object({
      private_link_vpce_id = string
    }))
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
    role_arn       = string
    retry_duration = optional(number, 60)
    s3_backup_mode = optional(string)
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
    secrets_manager_configuration = optional(object({
      enabled    = optional(bool)
      secret_arn = optional(string)
      role_arn   = optional(string)
    }))
  })
  default = null
  validation {
    condition = var.snowflake_configuration == null || (
      can(regex("^https://.*\\.snowflakecomputing\\.com$", var.snowflake_configuration.account_url)) &&
      can(regex("^arn:aws:iam:", var.snowflake_configuration.role_arn)) &&
      can(regex("^arn:aws:s3:", var.snowflake_configuration.s3_configuration.bucket_arn)) &&
      var.snowflake_configuration.buffering_size >= 1 && var.snowflake_configuration.buffering_size <= 128 &&
      var.snowflake_configuration.buffering_interval >= 0 && var.snowflake_configuration.buffering_interval <= 900 &&
      var.snowflake_configuration.retry_duration >= 0 && var.snowflake_configuration.retry_duration <= 7200 &&
      (var.snowflake_configuration.user != null || var.snowflake_configuration.secrets_manager_configuration != null) &&
      (var.snowflake_configuration.private_key != null || var.snowflake_configuration.secrets_manager_configuration != null)
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, snowflake_configuration must have valid Snowflake URL, ARNs, buffering values within limits, and either user/private_key or secrets_manager_configuration."
  }
}

variable "splunk_configuration" {
  description = "Configuration options when destination is splunk."
  type = object({
    buffering_interval         = optional(number, 60)
    buffering_size             = optional(number, 5)
    hec_acknowledgment_timeout = optional(number)
    hec_endpoint               = string
    hec_endpoint_type          = optional(string, "Raw")
    hec_token                  = optional(string)
    s3_configuration = object({
      role_arn            = string
      bucket_arn          = string
      prefix              = optional(string)
      buffering_size      = optional(number, 5)
      buffering_interval  = optional(number, 300)
      compression_format  = optional(string, "UNCOMPRESSED")
      error_output_prefix = optional(string)
      kms_key_arn         = optional(string)
      cloudwatch_logging_options = optional(object({
        enabled         = optional(bool, false)
        log_group_name  = optional(string)
        log_stream_name = optional(string)
      }))
    })
    s3_backup_mode = optional(string, "FailedEventsOnly")
    secrets_manager_configuration = optional(object({
      enabled    = optional(bool)
      secret_arn = optional(string)
      role_arn   = optional(string)
    }))
    retry_duration = optional(number, 300)
    cloudwatch_logging_options = optional(object({
      enabled         = optional(bool, false)
      log_group_name  = optional(string)
      log_stream_name = optional(string)
    }))
    processing_configuration = optional(object({
      enabled = optional(bool)
      processors = optional(list(object({
        type = string
        parameters = optional(list(object({
          parameter_name  = string
          parameter_value = string
        })))
      })))
    }))
  })
  default = null
  validation {
    condition = var.splunk_configuration == null || (
      can(regex("^https://", var.splunk_configuration.hec_endpoint)) &&
      can(regex("^arn:aws:s3:", var.splunk_configuration.s3_configuration.bucket_arn)) &&
      var.splunk_configuration.buffering_interval >= 0 && var.splunk_configuration.buffering_interval <= 60 &&
      var.splunk_configuration.buffering_size >= 1 && var.splunk_configuration.buffering_size <= 5 &&
      contains(["Raw", "Event"], var.splunk_configuration.hec_endpoint_type) &&
      contains(["FailedEventsOnly", "AllEvents"], var.splunk_configuration.s3_backup_mode) &&
      var.splunk_configuration.retry_duration >= 0 && var.splunk_configuration.retry_duration <= 7200 &&
      (var.splunk_configuration.hec_acknowledgment_timeout == null || (var.splunk_configuration.hec_acknowledgment_timeout >= 180 && var.splunk_configuration.hec_acknowledgment_timeout <= 600)) &&
      (var.splunk_configuration.hec_token != null || var.splunk_configuration.secrets_manager_configuration != null)
    )
    error_message = "resource_aws_kinesis_firehose_delivery_stream, splunk_configuration must have valid HTTPS endpoint, ARNs, buffering values within limits, valid endpoint type and backup mode, and either hec_token or secrets_manager_configuration."
  }
}