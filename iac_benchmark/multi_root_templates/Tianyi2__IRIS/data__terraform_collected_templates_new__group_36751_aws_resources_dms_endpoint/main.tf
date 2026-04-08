resource "aws_dms_endpoint" "this" {
  endpoint_id   = var.endpoint_id
  endpoint_type = var.endpoint_type
  engine_name   = var.engine_name

  # Optional arguments
  region                          = var.region
  certificate_arn                 = var.certificate_arn
  database_name                   = var.database_name
  extra_connection_attributes     = var.extra_connection_attributes
  kms_key_arn                     = var.kms_key_arn
  password                        = var.password
  port                            = var.port
  server_name                     = var.server_name
  service_access_role             = var.service_access_role
  ssl_mode                        = var.ssl_mode
  username                        = var.username
  pause_replication_tasks         = var.pause_replication_tasks
  secrets_manager_access_role_arn = var.secrets_manager_access_role_arn
  secrets_manager_arn             = var.secrets_manager_arn
  tags                            = var.tags

  # Configuration blocks
  dynamic "elasticsearch_settings" {
    for_each = var.elasticsearch_settings != null ? [var.elasticsearch_settings] : []
    content {
      endpoint_uri               = elasticsearch_settings.value.endpoint_uri
      error_retry_duration       = elasticsearch_settings.value.error_retry_duration
      full_load_error_percentage = elasticsearch_settings.value.full_load_error_percentage
      service_access_role_arn    = elasticsearch_settings.value.service_access_role_arn
      use_new_mapping_type       = elasticsearch_settings.value.use_new_mapping_type
    }
  }

  dynamic "kafka_settings" {
    for_each = var.kafka_settings != null ? [var.kafka_settings] : []
    content {
      broker                         = kafka_settings.value.broker
      include_control_details        = kafka_settings.value.include_control_details
      include_null_and_empty         = kafka_settings.value.include_null_and_empty
      include_partition_value        = kafka_settings.value.include_partition_value
      include_table_alter_operations = kafka_settings.value.include_table_alter_operations
      include_transaction_details    = kafka_settings.value.include_transaction_details
      message_format                 = kafka_settings.value.message_format
      message_max_bytes              = kafka_settings.value.message_max_bytes
      no_hex_prefix                  = kafka_settings.value.no_hex_prefix
      partition_include_schema_table = kafka_settings.value.partition_include_schema_table
      sasl_mechanism                 = kafka_settings.value.sasl_mechanism
      sasl_password                  = kafka_settings.value.sasl_password
      sasl_username                  = kafka_settings.value.sasl_username
      security_protocol              = kafka_settings.value.security_protocol
      ssl_ca_certificate_arn         = kafka_settings.value.ssl_ca_certificate_arn
      ssl_client_certificate_arn     = kafka_settings.value.ssl_client_certificate_arn
      ssl_client_key_arn             = kafka_settings.value.ssl_client_key_arn
      ssl_client_key_password        = kafka_settings.value.ssl_client_key_password
      topic                          = kafka_settings.value.topic
    }
  }

  dynamic "kinesis_settings" {
    for_each = var.kinesis_settings != null ? [var.kinesis_settings] : []
    content {
      include_control_details        = kinesis_settings.value.include_control_details
      include_null_and_empty         = kinesis_settings.value.include_null_and_empty
      include_partition_value        = kinesis_settings.value.include_partition_value
      include_table_alter_operations = kinesis_settings.value.include_table_alter_operations
      include_transaction_details    = kinesis_settings.value.include_transaction_details
      message_format                 = kinesis_settings.value.message_format
      partition_include_schema_table = kinesis_settings.value.partition_include_schema_table
      service_access_role_arn        = kinesis_settings.value.service_access_role_arn
      stream_arn                     = kinesis_settings.value.stream_arn
      use_large_integer_value        = kinesis_settings.value.use_large_integer_value
    }
  }

  dynamic "mongodb_settings" {
    for_each = var.mongodb_settings != null ? [var.mongodb_settings] : []
    content {
      auth_mechanism      = mongodb_settings.value.auth_mechanism
      auth_source         = mongodb_settings.value.auth_source
      auth_type           = mongodb_settings.value.auth_type
      docs_to_investigate = mongodb_settings.value.docs_to_investigate
      extract_doc_id      = mongodb_settings.value.extract_doc_id
      nesting_level       = mongodb_settings.value.nesting_level
    }
  }

  dynamic "oracle_settings" {
    for_each = var.oracle_settings != null ? [var.oracle_settings] : []
    content {
      authentication_method = oracle_settings.value.authentication_method
    }
  }

  dynamic "postgres_settings" {
    for_each = var.postgres_settings != null ? [var.postgres_settings] : []
    content {
      after_connect_script         = postgres_settings.value.after_connect_script
      authentication_method        = postgres_settings.value.authentication_method
      babelfish_database_name      = postgres_settings.value.babelfish_database_name
      capture_ddls                 = postgres_settings.value.capture_ddls
      database_mode                = postgres_settings.value.database_mode
      ddl_artifacts_schema         = postgres_settings.value.ddl_artifacts_schema
      execute_timeout              = postgres_settings.value.execute_timeout
      fail_tasks_on_lob_truncation = postgres_settings.value.fail_tasks_on_lob_truncation
      heartbeat_enable             = postgres_settings.value.heartbeat_enable
      heartbeat_frequency          = postgres_settings.value.heartbeat_frequency
      heartbeat_schema             = postgres_settings.value.heartbeat_schema
      map_boolean_as_boolean       = postgres_settings.value.map_boolean_as_boolean
      map_jsonb_as_clob            = postgres_settings.value.map_jsonb_as_clob
      map_long_varchar_as          = postgres_settings.value.map_long_varchar_as
      max_file_size                = postgres_settings.value.max_file_size
      plugin_name                  = postgres_settings.value.plugin_name
      service_access_role_arn      = postgres_settings.value.service_access_role_arn
      slot_name                    = postgres_settings.value.slot_name
    }
  }

  dynamic "redis_settings" {
    for_each = var.redis_settings != null ? [var.redis_settings] : []
    content {
      auth_password          = redis_settings.value.auth_password
      auth_type              = redis_settings.value.auth_type
      auth_user_name         = redis_settings.value.auth_user_name
      server_name            = redis_settings.value.server_name
      port                   = redis_settings.value.port
      ssl_ca_certificate_arn = redis_settings.value.ssl_ca_certificate_arn
      ssl_security_protocol  = redis_settings.value.ssl_security_protocol
    }
  }

  dynamic "redshift_settings" {
    for_each = var.redshift_settings != null ? [var.redshift_settings] : []
    content {
      bucket_folder                     = redshift_settings.value.bucket_folder
      bucket_name                       = redshift_settings.value.bucket_name
      encryption_mode                   = redshift_settings.value.encryption_mode
      server_side_encryption_kms_key_id = redshift_settings.value.server_side_encryption_kms_key_id
      service_access_role_arn           = redshift_settings.value.service_access_role_arn
    }
  }

  timeouts {
    create = var.timeouts.create
    delete = var.timeouts.delete
  }
}