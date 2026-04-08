variable "create" {
  description = "Controls if resources should be created (affects nearly all resources)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
  default     = {}
}

################################################################################
# Kinesis Firehouse Delivery Stream
################################################################################
variable "name" {
  description = "Name of the Kinesis Firehouse"
  type        = string
}

variable "destination" {
  description = "This is the destination to where the data is delivered. The only options are extended_s3, redshift, elasticsearch, splunk, http_endpoint and opensearch"
  type        = string
}

variable "kinesis_source_stream_enabled" {
  description = "Whether to enable kinesis stream as the source of the firehose delivery stream"
  type        = bool
  default     = false
}

variable "kinesis_source_configuration" {
  description = "Configuration of kinesis stream that is used as source. Must be provided if kinesis_source_stream_enabled is true"
  type = object({
    kinesis_stream_arn = string # The kinesis stream used as the source of the firehose delivery stream
    role_arn           = string # The ARN of the role that provides access to the source Kinesis stream
  })
  default = {
    kinesis_stream_arn = ""
    role_arn           = ""
  }
}

variable "server_side_encryption_enabled" {
  description = "Whether to enable encryption at rest"
  type        = bool
  default     = false
}

variable "server_side_encryption" {
  description = "Encrypt at rest options"
  type = object({
    key_type = optional(string, "AWS_OWNED_CMK")
    key_arn  = optional(string, null)
  })
  default = {}
}

variable "processing_configuration_enabled" {
  description = "Enables or disables data processing"
  type        = bool
  default     = false
}

variable "processing_configuration_processors" {
  description = "Array of data processors"
  type = list(object({
    type = string
    parameters = list(object({
      parameter_name  = string
      parameter_value = string
    }))
  }))
  default = []
}

variable "s3_backup_enable" {
  description = "Whether to enable Amazon S3 backup"
  type        = bool
  default     = false
}

variable "s3_backup_mode" {
  description = "Defines how documents should be delivered to Amazon S3. Used to elasticsearch, splunk, http configurations"
  type        = string
  default     = "FailedOnly"
  validation {
    error_message = "Valid values are FailedOnly and All."
    condition     = contains(["FailedOnly", "All"], var.s3_backup_mode)
  }
}

variable "s3_backup_configuration" {
  description = "Configuration for S3 backup"
  type = object({
    bucket_arn          = string                 # The ARN of the S3 bucket
    role_arn            = string                 # The ARN of the AWS credentials
    prefix              = optional(string, null) # You can specify an extra prefix to be added in front of the time format prefix
    buffering_size      = optional(number, null) # Buffer incoming data to the specified size, in MBs, before delivering it to the destination
    buffering_interval  = optional(number, null) # Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination
    compression_format  = optional(string, null) # The compression format. If no value is specified, the default is UNCOMPRESSED. Other supported values are GZIP, ZIP, Snappy, & HADOOP_SNAPPY
    error_output_prefix = optional(string, null) # Prefix added to failed records before writing them to S3
    kms_key_arn         = optional(string, null) # Specifies the KMS key ARN the stream will use to encrypt data
  })
  default = {
    bucket_arn = ""
    role_arn   = ""
  }
}

variable "s3_backup_cw_log_enable" {
  description = "Enables or disables the logging"
  type        = bool
  default     = false
}

variable "s3_backup_cw_log_create" {
  description = "Whether to create CloudWatch Log Group"
  type        = bool
  default     = false
}

variable "s3_backup_cw_log_group_name" {
  description = "The CloudWatch group name for logging"
  type        = string
  default     = null
}

variable "s3_backup_cw_log_stream_name" {
  description = "The CloudWatch log stream name for logging"
  type        = string
  default     = null
}

variable "destination_cw_log_enable" {
  description = "Whether to enable CloudWatch Logging for the delivery stream"
  type        = bool
  default     = false
}

variable "destination_cw_log_create" {
  description = "Whether to create CloudWatch Log Group"
  type        = bool
  default     = false
}

variable "cw_log_retention_in_days" {
  description = "Specifies the number of days you want to retain log events in the specified log group. Possible values are: 1, 3, 5, 7, 14, 30, 60, 90, 120, 150, 180, 365, 400, 545, 731, 1827, and 3653"
  type        = number
  default     = 30
}

variable "destination_cw_log_group_name" {
  description = "The CloudWatch group name for destination logs"
  type        = string
  default     = null
}

variable "destination_cw_log_stream_name" {
  description = "The CloudWatch log stream name for destination logs"
  type        = string
  default     = null
}

################################################################################
# S3 Destination
################################################################################

variable "s3_configuration" {
  description = "Enhanced configuration options for the s3 destination OR S3 configuration for Redshift, ElasticSearch, OpenSearch, Splunk and HTTP Endpoint destinations"
  type = object({
    bucket_arn          = string                 # The ARN of the S3 bucket
    role_arn            = string                 # The ARN of the AWS credentials
    prefix              = optional(string, null) # You can specify an extra prefix to be added in front of the time format prefix
    buffering_size      = optional(number, null) # Buffer incoming data to the specified size, in MBs, before delivering it to the destination
    buffering_interval  = optional(number, null) # Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination
    compression_format  = optional(string, null) # The compression format. If no value is specified, the default is UNCOMPRESSED. Other supported values are GZIP, ZIP, Snappy, & HADOOP_SNAPPY
    error_output_prefix = optional(string, null) # Prefix added to failed records before writing them to S3. Not currently supported for redshift destination
    kms_key_arn         = optional(string, null) # Specifies the KMS key ARN the stream will use to encrypt data
  })
  default = {
    bucket_arn = ""
    role_arn   = ""
  }
}

variable "extended_s3_data_format_conversion_enabled" {
  description = "Whether to enable format conversion"
  type        = bool
  default     = false
}

variable "data_format_conversion_input_format" {
  description = "Configuration that specifies the deserializer that you want Kinesis Data Firehose to use to convert the format of your data from JSON. Required if extended_s3_configuration_data_format_conversion_enabled is true"
  type = object({
    deserializer                                                = string                       # Deserializer to use. Possible options are hive_json_ser_de and open_x_json_ser_de
    hive_json_ser_de_timestamp_formats                          = optional(list(string), null) # A list of how you want Kinesis Data Firehose to parse the date and time stamps that may be present in your input data JSON. Provide only if deserializer is hive_json_ser_de
    open_x_json_ser_de_case_insensitive                         = optional(bool, null)         # When set to true, which is the default, Kinesis Data Firehose converts JSON keys to lowercase before deserializing them. Provide only if deserializer is open_x_json_ser_de
    open_x_json_ser_de_column_to_json_key_mappings              = optional(map(string), null)  # A map of column names to JSON keys that aren't identical to the column names. Provide only if deserializer is open_x_json_ser_de
    open_x_json_ser_de_convert_dots_in_json_keys_to_underscores = optional(bool, null)         # When set to true, specifies that the names of the keys include dots and that you want Kinesis Data Firehose to replace them with underscores. Provide only if deserializer is open_x_json_ser_de
  })
  default = {
    deserializer = ""
  }
}

variable "data_format_conversion_output_format" {
  description = "Configuration that specifies the serializer that you want Kinesis Data Firehose to use to convert the format of your data to the Parquet or ORC format. Required if extended_s3_configuration_data_format_conversion_enabled is true"
  type = object({
    serializer                                         = string                       # Serializer to use. Possible options are orc_ser_de and parquet_ser_de
    orc_ser_de_block_size_bytes                        = optional(number, null)       # The Hadoop Distributed File System (HDFS) block size. Provide only if serializer is orc_ser_de
    orc_ser_de_bloom_filter_columns                    = optional(list(string), null) # A list of column names for which you want Kinesis Data Firehose to create bloom filters. Provide only if serializer is orc_ser_de
    orc_ser_de_bloom_filter_false_positive_probability = optional(number, null)       # The Bloom filter false positive probability (FPP). Provide only if serializer is orc_ser_de
    orc_ser_de_compression                             = optional(string, null)       # The compression code to use over data blocks. Provide only if serializer is orc_ser_de
    orc_ser_de_dictionary_key_threshold                = optional(number, null)       # A float that represents the fraction of the total number of non-null rows. Provide only if serializer is orc_ser_de
    orc_ser_de_enable_padding                          = optional(bool, null)         # Set this to true to indicate that you want stripes to be padded to the HDFS block boundaries. Provide only if serializer is orc_ser_de
    orc_ser_de_format_version                          = optional(string, null)       # The version of the file to write. The possible values are V0_11 and V0_12. Provide only if serializer is orc_ser_de
    orc_ser_de_padding_tolerance                       = optional(number, null)       # A float between 0 and 1 that defines the tolerance for block padding as a decimal fraction of stripe size. Provide only if serializer is orc_ser_de
    orc_ser_de_row_index_stride                        = optional(number, null)       # The number of rows between index entries. Provide only if serializer is orc_ser_de
    orc_ser_de_stripe_size_bytes                       = optional(number, null)       # The number of bytes in each stripe. Provide only if serializer is orc_ser_de
    parquet_ser_de_block_size_bytes                    = optional(number, null)       # The Hadoop Distributed File System (HDFS) block size. Provide only if serializer is parquet_ser_de
    parquet_ser_de_compression                         = optional(string, null)       # The compression code to use over data blocks. The possible values are UNCOMPRESSED, SNAPPY, and GZIP. Provide only if serializer is parquet_ser_de
    parquet_ser_de_enable_dictionary_compression       = optional(bool, null)         # Indicates whether to enable dictionary compression. Provide only if serializer is parquet_ser_de
    parquet_ser_de_max_padding_bytes                   = optional(number, null)       # The maximum amount of padding to apply. Provide only if serializer is parquet_ser_de
    parquet_ser_de_page_size_bytes                     = optional(number, null)       # The Parquet page size. Provide only if serializer is parquet_ser_de
    parquet_ser_de_writer_version                      = optional(string, null)       #  Indicates the version of row format to output. The possible values are V1 and V2. Provide only if serializer is parquet_ser_de
  })
  default = {
    serializer = ""
  }
}

variable "data_format_conversion_schema_configuration" {
  description = "Configuration that specifies the AWS Glue Data Catalog table that contains the column information"
  type = object({
    database_name = string                 # Specifies the name of the AWS Glue database that contains the schema for the output data
    role_arn      = string                 # The role that Kinesis Data Firehose can use to access AWS Glue
    table_name    = string                 # Specifies the AWS Glue table that contains the column information that constitutes your data schema
    catalog_id    = optional(string, null) # The ID of the AWS Glue Data Catalog. If you don't supply this, the AWS account ID is used by default
    region        = optional(string, null) # If you don't specify an AWS Region, the default is the current region
    version_id    = optional(string, null) # Specifies the table version for the output data schema
  })
  default = {
    database_name = ""
    role_arn      = ""
    table_name    = ""
  }
}

variable "dynamic_partitioning_enable" {
  description = "Enables or disables dynamic partitioning"
  type        = bool
  default     = false
}

variable "dynamic_partitioning_retry_duration" {
  description = "Total amount of seconds Firehose spends on retries. Valid values between 0 and 7200"
  type        = number
  default     = 300
}

################################################################################
# Redshift Destination
################################################################################

variable "redshift_configuration" {
  description = "Configuration options for Redshift destination"
  type = object({
    cluster_jdbcurl    = string                 # The jdbcurl of the redshift cluster
    username           = string                 # The username that the firehose delivery stream will assume
    password           = string                 # The password for the username above
    retry_duration     = optional(number, null) # The length of time during which Firehose retries delivery after a failure, starting from the initial request and including the first attempt
    role_arn           = string                 # The arn of the role the stream assumes
    data_table_name    = string                 # The name of the table in the redshift cluster that the s3 bucket will copy to
    copy_options       = optional(string, null) # Copy options for copying the data from the s3 intermediate bucket into redshift, for example to change the default delimiter
    data_table_columns = optional(string, null) # The data table columns that will be targeted by the copy command
  })
  default = {
    cluster_jdbcurl = ""
    username        = ""
    password        = ""
    role_arn        = ""
    data_table_name = ""
  }
}

################################################################################
# ElasticSearch Destination
################################################################################

variable "elasticsearch_configuration" {
  description = "Configuration options for ElasticSearch destination"
  type = object({
    buffering_interval     = optional(number, null) # Buffer incoming data for the specified period of time
    buffering_size         = optional(number, null) # Buffer incoming data to the specified size, in MBs
    domain_arn             = optional(string, null) # The ARN of the Amazon ES domain
    cluster_endpoint       = optional(string, null) # The endpoint to use when communicating with the cluster
    index_name             = string                 # The Elasticsearch index name
    index_rotation_period  = optional(string, null) # The Elasticsearch index rotation period
    retry_duration         = optional(number, null) # After an initial failure to deliver to Amazon Elasticsearch, the total amount of time
    role_arn               = string                 # The ARN of the IAM role to be assumed by Firehose for calling the Amazon ES Configuration API and for indexing documents
    type_name              = optional(string, null) # The Elasticsearch type name with maximum length of 100 characters
    vpc_config_enabled     = optional(bool, false)  # The VPC configuration for the delivery stream to connect to Elastic Search associated with the VPC
    vpc_subnet_ids         = optional(list(string), [])
    vpc_security_group_ids = optional(list(string), [])
    vpc_role_arn           = optional(string, "")
  })
  default = {
    index_name = ""
    role_arn   = ""
  }
}

################################################################################
# OpenSearch Destination
################################################################################
variable "opensearch_configuration" {
  description = "Configuration options for OpenSearch destination"
  type = object({
    buffering_interval     = optional(number, null) # Buffer incoming data for the specified period of time
    buffering_size         = optional(number, null) # Buffer incoming data to the specified size, in MBs
    domain_arn             = optional(string, null) # The ARN of the Amazon ES domain
    cluster_endpoint       = optional(string, null) # The endpoint to use when communicating with the cluster
    index_name             = string                 # The Opensearch index name
    index_rotation_period  = optional(string, null) # The Opensearch index rotation period
    retry_duration         = optional(number, null) # After an initial failure to deliver to Amazon OpenSearch, the total amount of time
    role_arn               = string                 # The ARN of the IAM role to be assumed by Firehose for calling the Amazon ES Configuration API and for indexing documents
    type_name              = optional(string, null) # The Elasticsearch type name with maximum length of 100 characters
    vpc_config_enabled     = optional(bool, false)  # The VPC configuration for the delivery stream to connect to OpenSearch associated with the VPC
    vpc_subnet_ids         = optional(list(string), [])
    vpc_security_group_ids = optional(list(string), [])
    vpc_role_arn           = optional(string, "")
  })
  default = {
    index_name = ""
    role_arn   = ""
  }
}
################################################################################
# Splunk Destination
################################################################################
variable "splunk_configuration" {
  description = "Configuration options for Splunk destination"
  type = object({
    hec_acknowledgment_timeout = optional(number, null) # The amount of time, in seconds between 180 and 600, that Kinesis Firehose waits to receive an acknowledgment from Splunk after it sends it data
    hec_endpoint               = string                 # The HTTP Event Collector (HEC) endpoint to which Kinesis Firehose sends your data
    hec_endpoint_type          = optional(string, null) # The HEC endpoint type. Valid values are Raw or Event
    hec_token                  = string                 # The GUID that you obtain from your Splunk cluster when you create a new HEC endpoint
    retry_duration             = optional(number, null) # After an initial failure to deliver to Splunk, the total amount of time
  })
  default = {
    hec_endpoint = ""
    hec_token    = ""
  }
}
################################################################################
# HTTP Endpoint Destination
################################################################################
variable "http_endpoint_configuration" {
  description = "Configuration options for HTTP Endpoint destination"
  type = object({
    url                                    = string                 # The HTTP endpoint URL to which Kinesis Firehose sends your data
    name                                   = optional(string, null) # The HTTP endpoint name
    access_key                             = optional(string, null) # The access key required for Kinesis Firehose to authenticate with the HTTP endpoint selected as the destination
    role_arn                               = string                 # Kinesis Data Firehose uses this IAM role for all the permissions that the delivery stream needs
    buffering_size                         = optional(number, null) # Buffer incoming data to the specified size, in MBs, before delivering it to the destination
    buffering_interval                     = optional(number, null) # Buffer incoming data for the specified period of time, in seconds, before delivering it to the destination
    retry_duration                         = optional(number, null) # Total amount of seconds Firehose spends on retries
    request_configuration_enabled          = optional(bool, false)  # The request configuration
    request_configuration_content_encoding = optional(string, null)
    request_configuration_common_attributes = optional(list(object({
      name  = string
      value = string
    })), [])
  })
  default = {
    url      = ""
    role_arn = ""
  }
}
