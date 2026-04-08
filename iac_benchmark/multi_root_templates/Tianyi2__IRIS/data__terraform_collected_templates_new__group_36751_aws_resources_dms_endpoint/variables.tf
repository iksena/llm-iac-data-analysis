variable "endpoint_id" {
  description = "Database endpoint identifier. Identifiers must contain from 1 to 255 alphanumeric characters or hyphens, begin with a letter, contain only ASCII letters, digits, and hyphens, not end with a hyphen, and not contain two consecutive hyphens."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]*[a-zA-Z0-9]$", var.endpoint_id)) && length(var.endpoint_id) >= 1 && length(var.endpoint_id) <= 255 && !can(regex("--", var.endpoint_id))
    error_message = "resource_aws_dms_endpoint, endpoint_id must contain from 1 to 255 alphanumeric characters or hyphens, begin with a letter, contain only ASCII letters, digits, and hyphens, not end with a hyphen, and not contain two consecutive hyphens."
  }
}

variable "endpoint_type" {
  description = "Type of endpoint. Valid values are source, target."
  type        = string

  validation {
    condition     = contains(["source", "target"], var.endpoint_type)
    error_message = "resource_aws_dms_endpoint, endpoint_type must be either 'source' or 'target'."
  }
}

variable "engine_name" {
  description = "Type of engine for the endpoint. Valid values are aurora, aurora-postgresql, aurora-serverless, aurora-postgresql-serverless, azuredb, azure-sql-managed-instance, babelfish, db2, db2-zos, docdb, dynamodb, elasticsearch, kafka, kinesis, mariadb, mongodb, mysql, opensearch, oracle, postgres, redshift, redshift-serverless, s3, sqlserver, neptune, sybase."
  type        = string

  validation {
    condition = contains([
      "aurora", "aurora-postgresql", "aurora-serverless", "aurora-postgresql-serverless",
      "azuredb", "azure-sql-managed-instance", "babelfish", "db2", "db2-zos", "docdb",
      "dynamodb", "elasticsearch", "kafka", "kinesis", "mariadb", "mongodb", "mysql",
      "opensearch", "oracle", "postgres", "redshift", "redshift-serverless", "s3",
      "sqlserver", "neptune", "sybase"
    ], var.engine_name)
    error_message = "resource_aws_dms_endpoint, engine_name must be one of the supported engine types."
  }
}

variable "region" {
  description = "Region where this resource will be managed. Defaults to the Region set in the provider configuration."
  type        = string
  default     = null
}

variable "certificate_arn" {
  description = "ARN for the certificate."
  type        = string
  default     = null
}

variable "database_name" {
  description = "Name of the endpoint database."
  type        = string
  default     = null
}

variable "extra_connection_attributes" {
  description = "Additional attributes associated with the connection. For available attributes for a source Endpoint, see Sources for data migration. For available attributes for a target Endpoint, see Targets for data migration."
  type        = string
  default     = null
}

variable "kms_key_arn" {
  description = "ARN for the KMS key that will be used to encrypt the connection parameters. If you do not specify a value for kms_key_arn, then AWS DMS will use your default encryption key. Required when engine_name is mongodb, optional otherwise."
  type        = string
  default     = null
}

variable "password" {
  description = "Password to be used to login to the endpoint database."
  type        = string
  default     = null
  sensitive   = true
}

variable "port" {
  description = "Port used by the endpoint database."
  type        = number
  default     = null
}

variable "server_name" {
  description = "Host name of the server."
  type        = string
  default     = null
}

variable "service_access_role" {
  description = "ARN used by the service access IAM role for dynamodb endpoints."
  type        = string
  default     = null
}

variable "ssl_mode" {
  description = "SSL mode to use for the connection. Valid values are none, require, verify-ca, verify-full."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "require", "verify-ca", "verify-full"], var.ssl_mode)
    error_message = "resource_aws_dms_endpoint, ssl_mode must be one of: none, require, verify-ca, verify-full."
  }
}

variable "username" {
  description = "User name to be used to login to the endpoint database."
  type        = string
  default     = null
}

variable "pause_replication_tasks" {
  description = "Whether to pause associated running replication tasks, regardless if they are managed by Terraform, prior to modifying the endpoint. Only tasks paused by the resource will be restarted after the modification completes."
  type        = bool
  default     = false
}

variable "secrets_manager_access_role_arn" {
  description = "ARN of the IAM role that specifies AWS DMS as the trusted entity and has the required permissions to access the value in the Secrets Manager secret referred to by secrets_manager_arn."
  type        = string
  default     = null
}

variable "secrets_manager_arn" {
  description = "Full ARN, partial ARN, or friendly name of the Secrets Manager secret that contains the endpoint connection details. Supported only when engine_name is aurora, aurora-postgresql, mariadb, mongodb, mysql, oracle, postgres, redshift, or sqlserver."
  type        = string
  default     = null
}

variable "tags" {
  description = "Map of tags to assign to the resource. If configured with a provider default_tags configuration block present, tags with matching keys will overwrite those defined at the provider-level."
  type        = map(string)
  default     = {}
}

variable "elasticsearch_settings" {
  description = "Configuration block for OpenSearch settings."
  type = object({
    endpoint_uri               = string
    error_retry_duration       = optional(number, 300)
    full_load_error_percentage = optional(number, 10)
    service_access_role_arn    = string
    use_new_mapping_type       = optional(bool, false)
  })
  default = null
}

variable "kafka_settings" {
  description = "Configuration block for Kafka settings."
  type = object({
    broker                         = string
    include_control_details        = optional(bool, false)
    include_null_and_empty         = optional(bool, false)
    include_partition_value        = optional(bool, false)
    include_table_alter_operations = optional(bool, false)
    include_transaction_details    = optional(bool, false)
    message_format                 = optional(string, "JSON")
    message_max_bytes              = optional(number, 1000000)
    no_hex_prefix                  = optional(bool)
    partition_include_schema_table = optional(bool, false)
    sasl_mechanism                 = optional(string)
    sasl_password                  = optional(string)
    sasl_username                  = optional(string)
    security_protocol              = optional(string)
    ssl_ca_certificate_arn         = optional(string)
    ssl_client_certificate_arn     = optional(string)
    ssl_client_key_arn             = optional(string)
    ssl_client_key_password        = optional(string)
    topic                          = optional(string, "kafka-default-topic")
  })
  default = null

  validation {
    condition     = var.kafka_settings == null || contains(["JSON", "JSON_UNFORMATTED"], var.kafka_settings.message_format)
    error_message = "resource_aws_dms_endpoint, kafka_settings.message_format must be either 'JSON' or 'JSON_UNFORMATTED'."
  }

  validation {
    condition     = var.kafka_settings == null || var.kafka_settings.sasl_mechanism == null || contains(["scram-sha-512", "plain"], var.kafka_settings.sasl_mechanism)
    error_message = "resource_aws_dms_endpoint, kafka_settings.sasl_mechanism must be either 'scram-sha-512' or 'plain'."
  }

  validation {
    condition     = var.kafka_settings == null || var.kafka_settings.security_protocol == null || contains(["ssl-encryption", "ssl-authentication", "sasl-ssl"], var.kafka_settings.security_protocol)
    error_message = "resource_aws_dms_endpoint, kafka_settings.security_protocol must be one of: ssl-encryption, ssl-authentication, sasl-ssl."
  }
}

variable "kinesis_settings" {
  description = "Configuration block for Kinesis settings."
  type = object({
    include_control_details        = optional(bool, false)
    include_null_and_empty         = optional(bool, false)
    include_partition_value        = optional(bool, false)
    include_table_alter_operations = optional(bool, false)
    include_transaction_details    = optional(bool, false)
    message_format                 = optional(string, "json")
    partition_include_schema_table = optional(bool, false)
    service_access_role_arn        = optional(string)
    stream_arn                     = optional(string)
    use_large_integer_value        = optional(bool, false)
  })
  default = null

  validation {
    condition     = var.kinesis_settings == null || contains(["json", "json-unformatted"], var.kinesis_settings.message_format)
    error_message = "resource_aws_dms_endpoint, kinesis_settings.message_format must be either 'json' or 'json-unformatted'."
  }
}

variable "mongodb_settings" {
  description = "Configuration block for MongoDB settings."
  type = object({
    auth_mechanism      = optional(string, "default")
    auth_source         = optional(string, "admin")
    auth_type           = optional(string, "password")
    docs_to_investigate = optional(number, 1000)
    extract_doc_id      = optional(bool, false)
    nesting_level       = optional(string, "none")
  })
  default = null

  validation {
    condition     = var.mongodb_settings == null || contains(["one", "none"], var.mongodb_settings.nesting_level)
    error_message = "resource_aws_dms_endpoint, mongodb_settings.nesting_level must be either 'one' or 'none'."
  }
}

variable "oracle_settings" {
  description = "Configuration block for Oracle settings."
  type = object({
    authentication_method = optional(string, "password")
  })
  default = null

  validation {
    condition     = var.oracle_settings == null || contains(["password", "kerberos"], var.oracle_settings.authentication_method)
    error_message = "resource_aws_dms_endpoint, oracle_settings.authentication_method must be either 'password' or 'kerberos'."
  }
}

variable "postgres_settings" {
  description = "Configuration block for Postgres settings."
  type = object({
    after_connect_script         = optional(string)
    authentication_method        = optional(string)
    babelfish_database_name      = optional(string)
    capture_ddls                 = optional(bool)
    database_mode                = optional(string)
    ddl_artifacts_schema         = optional(string, "public")
    execute_timeout              = optional(number, 60)
    fail_tasks_on_lob_truncation = optional(bool, false)
    heartbeat_enable             = optional(bool)
    heartbeat_frequency          = optional(number, 5)
    heartbeat_schema             = optional(string, "public")
    map_boolean_as_boolean       = optional(bool, false)
    map_jsonb_as_clob            = optional(bool)
    map_long_varchar_as          = optional(bool)
    max_file_size                = optional(number, 32768)
    plugin_name                  = optional(string)
    service_access_role_arn      = optional(string)
    slot_name                    = optional(string)
  })
  default = null

  validation {
    condition     = var.postgres_settings == null || var.postgres_settings.authentication_method == null || contains(["password", "iam"], var.postgres_settings.authentication_method)
    error_message = "resource_aws_dms_endpoint, postgres_settings.authentication_method must be either 'password' or 'iam'."
  }

  validation {
    condition     = var.postgres_settings == null || var.postgres_settings.plugin_name == null || contains(["pglogical", "test_decoding"], var.postgres_settings.plugin_name)
    error_message = "resource_aws_dms_endpoint, postgres_settings.plugin_name must be either 'pglogical' or 'test_decoding'."
  }
}

variable "redis_settings" {
  description = "Configuration block for Redis settings."
  type = object({
    auth_password          = optional(string)
    auth_type              = string
    auth_user_name         = optional(string)
    server_name            = string
    port                   = number
    ssl_ca_certificate_arn = optional(string)
    ssl_security_protocol  = optional(string, "ssl-encryption")
  })
  default = null

  validation {
    condition     = var.redis_settings == null || contains(["none", "auth-token", "auth-role"], var.redis_settings.auth_type)
    error_message = "resource_aws_dms_endpoint, redis_settings.auth_type must be one of: none, auth-token, auth-role."
  }

  validation {
    condition     = var.redis_settings == null || var.redis_settings.ssl_security_protocol == null || contains(["plaintext", "ssl-encryption"], var.redis_settings.ssl_security_protocol)
    error_message = "resource_aws_dms_endpoint, redis_settings.ssl_security_protocol must be either 'plaintext' or 'ssl-encryption'."
  }
}

variable "redshift_settings" {
  description = "Configuration block for Redshift settings."
  type = object({
    bucket_folder                     = optional(string)
    bucket_name                       = optional(string)
    encryption_mode                   = optional(string, "SSE_S3")
    server_side_encryption_kms_key_id = optional(string)
    service_access_role_arn           = optional(string)
  })
  default = null

  validation {
    condition     = var.redshift_settings == null || contains(["SSE_S3", "SSE_KMS"], var.redshift_settings.encryption_mode)
    error_message = "resource_aws_dms_endpoint, redshift_settings.encryption_mode must be either 'SSE_S3' or 'SSE_KMS'."
  }
}

variable "timeouts" {
  description = "Configuration options for resource timeouts."
  type = object({
    create = optional(string, "5m")
    delete = optional(string, "10m")
  })
  default = {
    create = "5m"
    delete = "10m"
  }
}